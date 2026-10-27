-- PBI 88921 - GenAI Events Tracker
-- Creates genai_audit_log in the audit DB (same structure as AEF dev + client_id).
-- Idempotent and create-only: safe to re-run.

CREATE TABLE IF NOT EXISTS genai_audit_log (
    genai_audit_log_id BIGSERIAL PRIMARY KEY,
    user_id            INTEGER,
    client_id          INTEGER,
    step               VARCHAR(255) NOT NULL,
    sub_step           VARCHAR(255),
    progress           INTEGER      NOT NULL DEFAULT 0,
    status             VARCHAR(50)  NOT NULL DEFAULT 'In Progress',
    requested_time     TIMESTAMPTZ,
    event_time         TIMESTAMPTZ  NOT NULL DEFAULT now(),
    log_history        JSONB
);

-- adds client_id if the table was created earlier without it
ALTER TABLE genai_audit_log ADD COLUMN IF NOT EXISTS client_id INTEGER;

CREATE INDEX IF NOT EXISTS ix_genai_audit_log_step_sub   ON genai_audit_log (step, sub_step);
CREATE INDEX IF NOT EXISTS ix_genai_audit_log_user_id    ON genai_audit_log (user_id);
CREATE INDEX IF NOT EXISTS ix_genai_audit_log_client_id  ON genai_audit_log (client_id);
CREATE INDEX IF NOT EXISTS ix_genai_audit_log_status     ON genai_audit_log (status);
CREATE INDEX IF NOT EXISTS ix_genai_audit_log_event_time ON genai_audit_log (event_time);
