SET DATABASE = bank;
CREATE USER IF NOT EXISTS roach WITH PASSWORD 'roach';
GRANT ALL ON DATABASE bank TO roach;