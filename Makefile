postgres:
	docker run --name some-postgres --network bank-network -e POSTGRES_PASSWORD=password -e POSTGRES_USER=root -p 5432:5432 -d postgres

mysql:
	docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 -d mysql

migratefile:
	migrate create -ext sql -dir db/migration -seq init_schema

createdb:
	docker exec -it some-postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it some-postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose down 1

dirtystatus:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose status

# dirtyfix:
# 	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose force 

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/auliardana/simple-bank/db/sqlc Store
	
.PHONY: postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test server mock