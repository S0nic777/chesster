-- Enable UUID extension if needed (gen_random_uuid is built-in in modern pg, but good to ensure)
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create Enum Types
CREATE TYPE competition_status AS ENUM ('open', 'active', 'tie_breaker', 'completed', 'unfilled');
CREATE TYPE match_status AS ENUM ('active', 'analyzing', 'finished');

-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT UNIQUE NOT NULL,
    elo_rating INT DEFAULT 1200,
    wallet_earned INT DEFAULT 0, -- App logic enforces cap (50 or 250)
    wallet_purchased INT DEFAULT 0,
    is_premium BOOLEAN DEFAULT FALSE,
    is_suspicious BOOLEAN DEFAULT FALSE,
    games_played INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create competitions table
CREATE TABLE competitions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tier_id TEXT NOT NULL,
    status competition_status DEFAULT 'open',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    closes_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Create competition_entries table
CREATE TABLE competition_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    competition_id UUID REFERENCES competitions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    matches_played INT DEFAULT 0,
    win_points INT DEFAULT 0,
    bonus_points INT DEFAULT 0,
    raw_mqi_total FLOAT DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(competition_id, user_id)
);

-- Create matches table
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    comp_id UUID REFERENCES competitions(id) ON DELETE SET NULL,
    white_user_id UUID REFERENCES users(id),
    black_user_id UUID REFERENCES users(id),
    pgn_data TEXT,
    status match_status DEFAULT 'active',
    white_mqi FLOAT,
    black_mqi FLOAT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
