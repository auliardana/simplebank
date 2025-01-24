CREATE TABLE "users" (
  "username" varchar PRIMARY KEY,
  "hashed_password" varchar NOT NULL,
  "full_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password_changed_at" timestamptz NOT NULL DEFAULT '0001-01-01 00:00:00Z',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);



ALTER TABLE "accounts" ADD FOREIGN KEY ("owner") REFERENCES "users" ("username");

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'owner_currency_unique') THEN
      ALTER TABLE "accounts" ADD CONSTRAINT "owner_currency_unique" UNIQUE ("owner", "currency");
   END IF;
END $$;