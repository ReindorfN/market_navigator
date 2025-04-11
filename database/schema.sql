-- Market Navigator Database Schema

-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    user_role VARCHAR(20) CHECK (user_role IN ('seller', 'customer')) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- User preferences table
CREATE TABLE user_preferences (
    preference_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    language VARCHAR(10) DEFAULT 'en',
    currency VARCHAR(3) DEFAULT 'USD',
    measurement_system VARCHAR(10) DEFAULT 'metric',
    notification_enabled BOOLEAN DEFAULT true,
    dark_mode BOOLEAN DEFAULT false,
    max_search_radius INTEGER DEFAULT 10, -- in kilometers
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_name VARCHAR(50),
    parent_category_id INTEGER REFERENCES categories(category_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INTEGER REFERENCES categories(category_id),
    brand VARCHAR(100),
    model VARCHAR(100),
    specifications JSONB, -- Store product specifications as JSON
    image_urls TEXT[], -- Array of image URLs
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Shops table
CREATE TABLE shops (
    shop_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    operating_hours JSONB, -- Store operating hours as JSON
    rating DECIMAL(3, 2),
    total_ratings INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Shop products table (for tracking which shops sell which products)
CREATE TABLE shop_products (
    shop_product_id SERIAL PRIMARY KEY,
    shop_id INTEGER REFERENCES shops(shop_id),
    product_id INTEGER REFERENCES products(product_id),
    price DECIMAL(10, 2) NOT NULL,
    stock_status VARCHAR(20), -- 'in_stock', 'out_of_stock', 'limited'
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(shop_id, product_id)
);

-- --Might not need this
-- -- Price history table
-- CREATE TABLE price_history (
--     price_history_id SERIAL PRIMARY KEY,
--     shop_product_id INTEGER REFERENCES shop_products(shop_product_id),
--     price DECIMAL(10, 2) NOT NULL,
--     recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- User favorites table
CREATE TABLE user_favorites (
    favorite_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    product_id INTEGER REFERENCES products(product_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, product_id)
);

-- User search history table
CREATE TABLE search_history (
    search_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    search_query TEXT NOT NULL,
    search_filters JSONB, -- Store search filters as JSON
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Shop reviews table
CREATE TABLE shop_reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    shop_id INTEGER REFERENCES shops(shop_id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--This feature might come later
-- Price alerts table
-- CREATE TABLE price_alerts (
--     alert_id SERIAL PRIMARY KEY,
--     user_id INTEGER REFERENCES users(user_id),
--     product_id INTEGER REFERENCES products(product_id),
--     target_price DECIMAL(10, 2),
--     is_active BOOLEAN DEFAULT true,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- Create indexes for better query performance
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_shop_products_shop ON shop_products(shop_id);
CREATE INDEX idx_shop_products_product ON shop_products(product_id);
-- CREATE INDEX idx_price_history_shop_product ON price_history(shop_product_id);
CREATE INDEX idx_user_favorites_user ON user_favorites(user_id);
CREATE INDEX idx_user_favorites_product ON user_favorites(product_id);
CREATE INDEX idx_search_history_user ON search_history(user_id);
CREATE INDEX idx_shop_reviews_shop ON shop_reviews(shop_id);
-- CREATE INDEX idx_price_alerts_user ON price_alerts(user_id);
-- CREATE INDEX idx_price_alerts_product ON price_alerts(product_id);

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updating the updated_at column
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shop_products_updated_at
    BEFORE UPDATE ON shop_products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shops_updated_at
    BEFORE UPDATE ON shops
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shop_reviews_updated_at
    BEFORE UPDATE ON shop_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_price_alerts_updated_at
    BEFORE UPDATE ON price_alerts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 