-- Product Label Bot - Initial Schema
-- Generated: 2025-10-25 12:52 IST
-- Source: Supabase production export

CREATE TABLE bot_sessions (
  telegram_user_id int8 NOT NULL,
  photo_url text,
  extracted_data jsonb,
  payment_methods _text,
  status text DEFAULT 'active'::text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE bot_users (
  telegram_user_id int8 NOT NULL,
  name text,
  username text,
  is_approved bool DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE brand_templates (
  id int4 NOT NULL DEFAULT nextval('brand_templates_id_seq'::regclass),
  brand_name text NOT NULL,
  detection_patterns jsonb NOT NULL,
  extraction_patterns jsonb NOT NULL,
  mandatory_fields jsonb NOT NULL,
  priority int4 DEFAULT 99,
  is_active bool DEFAULT true,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE customers (
  id int8 NOT NULL DEFAULT nextval('customers_id_seq'::regclass),
  name text NOT NULL,
  gstin text,
  mobile text,
  email text,
  address text
);

CREATE TABLE payments (
  id int8 NOT NULL DEFAULT nextval('payments_id_seq'::regclass),
  sale_id int8,
  payment_method text NOT NULL,
  payment_id text NOT NULL,
  amount numeric,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE products (
  id int8 NOT NULL DEFAULT nextval('products_id_seq'::regclass),
  serial_number text,
  manufacturer text,
  model text,
  ean_number text,
  created_at timestamptz DEFAULT now(),
  imei2_number text,
  brand text,
  model_number text,
  model_name text,
  product_code text,
  colour text,
  ram text,
  storage text,
  imei2 text,
  product_category text DEFAULT 'MOBILE'::text
);

CREATE TABLE sale_images (
  id int8 NOT NULL DEFAULT nextval('sale_images_id_seq'::regclass),
  sale_id int8,
  photo_url text NOT NULL,
  blur_score numeric,
  ocr_text text,
  created_at timestamptz DEFAULT now(),
  telegram_url text,
  permanent_url text
);

CREATE TABLE sales (
  id int8 NOT NULL DEFAULT nextval('sales_id_seq'::regclass),
  product_id int8,
  telegram_user_id int8 NOT NULL,
  sale_date date DEFAULT CURRENT_DATE,
  total_amount numeric,
  taxable_value numeric,
  gst_amount numeric,
  created_at timestamptz DEFAULT now()
);

-- Key insights:
-- brand_templates: Uses JSONB for flexible pattern matching
-- - detection_patterns: How to identify this brand in OCR text
-- - extraction_patterns: How to extract fields from OCR text
-- - mandatory_fields: Required fields for this brand
