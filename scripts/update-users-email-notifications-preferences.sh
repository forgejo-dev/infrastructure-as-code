#!/bin/bash

#
# This script updates the 'email_notifications_preference' of some users to 'onmention' to prevent
# large amounts of notification emails.
#

# Some useful comments for psql:
# SELECT * FROM public.user WHERE public.user.lower_name = 'maxkratz';
# UPDATE public.user SET email_notifications_preference = 'onmention' WHERE public.user.lower_name = 'maxkratz';

# The actual script:

declare -a users=(
    "maxkratz"
)

for u in "${users[@]}"
do
    docker compose exec -it db psql -U forgejo -c "UPDATE public.user SET email_notifications_preference = 'onmention' WHERE public.user.lower_name = '$u';"
done

exit 0;
