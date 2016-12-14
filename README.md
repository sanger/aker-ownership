# aker_ownership

Simple storal/retrieval of ownership for uuid resources.

## API description

- Create a new ownership
```HTTP
POST /ownerships
Content-Type: application/json; charset=utf-8

{
  "ownership": {
    "owner_id": "An email",
    "model_id": "<UUID>",
    "model_type": "An identification string"
  }
}
```
- Retrieve an ownership information
```HTTP
GET /ownerships/<UUID>
```

## Running
* Generate swagger API docs in /api-docs:
```bash
rake rswag:specs:swaggerize
rake assets:precompile
```
* Start the server
```bash
rails s
```
