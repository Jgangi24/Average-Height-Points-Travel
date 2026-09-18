-- Cleans up points_pots.label to hold just the plain name (no owner prefix,
-- no "pot"/"account" suffix baked in) -- the app now composes the full
-- display text (owner + label + points/miles) at render time instead,
-- which is what fixes the "Jess's Jess's ... pot" duplication.

update points_pots set label = 'Sapphire Preferred' where label = 'Abby''s Sapphire Preferred pot';
update points_pots set label = 'Ink Business Preferred' where label = 'Abby''s Ink Business Preferred pot';
update points_pots set label = 'Ink Business Unlimited' where label = 'Abby''s Ink Business Unlimited pot';
update points_pots set label = 'Sapphire Preferred' where label = 'Jess''s Sapphire Preferred pot';
update points_pots set label = 'Ink Business Preferred' where label = 'Jess''s Ink Business Preferred pot';
update points_pots set label = 'Ink Business Unlimited' where label = 'Jess''s Ink Business Unlimited pot';
update points_pots set label = 'Venture X' where label = 'Jess''s Venture X pot';
update points_pots set label = 'Platinum and Gold' where label = 'Platinum and Gold pot';
update points_pots set label = 'Hilton Honors' where label = 'Hilton Honors account';
update points_pots set label = 'Marriott Bonvoy' where label = 'Marriott Bonvoy account';
