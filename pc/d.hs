-- compute doubling time from two points (most recent first)
-- and time difference
d2 psa2 psa1 dt = (log 2) / (log (psa2/psa1)/dt)
