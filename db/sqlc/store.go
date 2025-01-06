package db

import (
	"context"
	"database/sql"
)

// store provide all functions to execute db queries and transactions
type store struct {
	*Queries
	db *sql.DB
}

func NewStore(db *sql.DB) *store {
	return &store{
		Queries: New(db),
		db:      db,
	}
}

// execTx executes a function within a database transaction
func (store *store) execTx(fn func(*Queries) error) error {
	tx, err := store.db.Begin()
	if err != nil {
		return err
	}

	q := New(tx)
	err = fn(q)
	if err != nil {
		if rbErr := tx.Rollback(); rbErr != nil {
			return rbErr
		}
		return err
	}

	return tx.Commit()
}

// transferTXParams contains the input parameters of the transfer transaction
type TransferTxParams struct {
	FromAccountID int64 `json:"from_account_id"`
	ToAccountID   int64 `json:"to_account_id"`
	Amount        int64 `json:"amount"`
}

type TransferTxResult struct {
	Transfer    Transfer `json:"transfer"`
	FromAccount Account  `json:"from_account"`
	ToAccount   Account  `json:"to_account"`
	FromEntry   Entry    `json:"from_entry"`
	ToEntry     Entry    `json:"to_entry"`
}

// transferTx performs a money transfer from one account to the other
// It creates a transfer record, add account entries and update account balance within a single transaction
func (store *store) TransferTx(ctx context.Context, arg TransferTxParams) (TransferTxResult, error) {
	var result TransferTxResult
	err := store.execTx(func(q *Queries) error {
		var err error
		// result.Transfer, err = q.CreateTransfer(ctx, CreateTransferParams{
		// 	FromAccountID: arg.FromAccountID,
		// 	ToAccountID:   arg.ToAccountID,
		// 	Amount:        arg.Amount,
		// })
		createTransferParams := CreateTransferParams(arg)
		result.Transfer, err = q.CreateTransfer(ctx, createTransferParams)
		if err != nil {
			return err
		}

		result.FromEntry, err = q.CreateEntry(ctx, CreateEntryParams{
			AccountID: arg.FromAccountID,
			Amount:    -arg.Amount,
		})
		if err != nil {
			return err
		}

		result.ToEntry, err = q.CreateEntry(ctx, CreateEntryParams{
			AccountID: arg.ToAccountID,
			Amount:    arg.Amount,
		})
		if err != nil {
			return err
		}

		//TODO: update account balance
		

		return nil

	})
	return result, err

}
