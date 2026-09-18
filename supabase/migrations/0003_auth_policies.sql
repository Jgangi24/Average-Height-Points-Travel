-- Once someone is logged in (Jess or Abby), they can see and edit everything.
-- No public/anonymous access -- only signed-in users pass these checks.

create policy "Authenticated users have full access" on programs
  for all to authenticated using (true) with check (true);

create policy "Authenticated users have full access" on points_pots
  for all to authenticated using (true) with check (true);

create policy "Authenticated users have full access" on cards
  for all to authenticated using (true) with check (true);

create policy "Authenticated users have full access" on perks
  for all to authenticated using (true) with check (true);

create policy "Authenticated users have full access" on perk_redemptions
  for all to authenticated using (true) with check (true);

create policy "Authenticated users have full access" on alerts
  for all to authenticated using (true) with check (true);
