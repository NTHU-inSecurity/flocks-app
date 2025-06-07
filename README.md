# Flocks App

Flocks App is the frontend web application for sharing and tracking location with friends. Users can join groups (called *flocks*) and view each other's positions and meeting points in real-time.

---

## Install

Clone the relevant branch and install dependencies:

```bash
bundle install
```

---

## Security Setup

Before launching the app, you must set up your `secrets.yml` file with the required keys.

Start by copying the example config:

```bash
cp config/secrets_example.yml config/secrets.yml
```

### Generate required secrets

Run the following tasks to generate values for `SESSION_SECRET` and `MSG_KEY`:

```bash
rake generate:session_secret
# => SESSION_SECRET: <copy this to config/secrets.yml>

rake generate:msg_key
# => MSG_KEY: <copy this to config/secrets.yml>
```

### Signing Key

This value (`SIGNING_KEY`) is obtained from the [Flocks API project](https://github.com/NTHU-inSecurity/flocks-api). You must run the API first and copy the key it provides.

---

## Execute

Start the application in development mode:

```bash
rake run:dev
```

Make sure the API is also running. You can configure the API base URL via the `API_URL` field in `config/secrets.yml`.

---

## Console

To launch an interactive console with app context:

```bash
rake console
```

---

## Test

To run all test specs:

```bash
rake spec
```

To rerun tests on code changes:

```bash
rake respec
```

---

## Style & Audit

Run style checks and security audit:

```bash
rake style     # Auto-correct style issues
rake audit     # Check for gem vulnerabilities
```

To verify readiness for release:

```bash
rake release
```

---

## Notes

- Port: The web app runs on `localhost:9292` by default
- Sessions are stored in Redis (in production). To clear them:

```bash
rake session:wipe
```

- To generate a Subresource Integrity (SRI) hash for external scripts:

```bash
rake url:integrity URL=https://example.com/script.js
```
