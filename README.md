# INF 345 Notes API

A small HTTP Notes API created for the INF 345 Fundamentals of DevOps course.

## What it does

This project is a small HTTP service written in Java.

Available endpoints:

- `GET /` - returns a greeting
- `GET /healthz` - returns `OK` for health checks
- `GET /notes` - returns a hard-coded list of notes

## Run

Start the service with:

```bash
./scripts/run.sh
```

## Port

The service uses the `PORT` environment variable.

If `PORT` is not set, the default port is `8080`.

Example with a custom port:

```bash
PORT=5000 ./scripts/run.sh
```

Then the service is available at:

```text
http://localhost:5000
```

## Test

Run all automated tests with:

```bash
./scripts/test.sh
```

The test script checks the `/`, `/healthz`, and `/notes` endpoints.

A successful run prints:

```text
TESTS: 3/3
```

## Course

INF 345 - Fundamentals of DevOps