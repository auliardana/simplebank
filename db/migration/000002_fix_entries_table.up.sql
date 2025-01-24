ALTER TABLE "entries" ALTER COLUMN "account_id" SET NOT NULL;
ALTER TABLE "entries" ALTER COLUMN "created_at" SET DEFAULT now();