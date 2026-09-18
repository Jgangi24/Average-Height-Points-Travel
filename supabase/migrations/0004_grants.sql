-- Grants basic table access to logged-in users. Row Level Security (from
-- 0003) still controls what they can actually do -- this just lets the
-- "authenticated" role touch these tables at all.

grant usage on schema public to authenticated;
grant select, insert, update, delete on all tables in schema public to authenticated;
