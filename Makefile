postgres:
	docker run --name some-postgres -e POSTGRES_PASSWORD=password -e POSTGRES_USER=root -p 5432:5432 -d postgres

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

migratedown:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose down

dirtystatus:
	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose status

# dirtyfix:
# 	migrate -path db/migration -database "postgres://root:password@localhost/simple_bank?sslmode=disable" -verbose force 

sqlc:
	sqlc generate

test:
	go test -v -cover ./...
	
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test