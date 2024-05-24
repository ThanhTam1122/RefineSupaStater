CREATE TYPE todo_status_enum AS ENUM (
  'None',
  'Progress',
  'Completed'
);

CREATE TABLE IF NOT EXISTS public.todolist (
  id uuid PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  status todo_status_enum NOT NULL DEFAULT 'None',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 1. Enable RLS
ALTER TABLE public.todolist ENABLE ROW LEVEL SECURITY;

-- 2. Create Policy for SELECT
CREATE POLICY select_all_policy ON public.todolist FOR
SELECT USING (TRUE);

-- 3. Create Policy for INSERT
CREATE POLICY insert_auth_policy ON public.todolist FOR
INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- 4. Create Policy for UPDATE
CREATE POLICY update_auth_policy ON public.todolist FOR
UPDATE USING (auth.uid() = id);