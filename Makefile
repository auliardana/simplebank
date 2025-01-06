createdb:
	docker exec -it some-postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it some-postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test