-- Optional date a perk's window opens, for perks that aren't usable yet
-- (shows in the "Upcoming redeemables" section until this date arrives).
alter table perks add column starts_on date;
