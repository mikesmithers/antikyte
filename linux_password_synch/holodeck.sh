#!/bin/bash
echo -n "Enter User's Name : "
read userName
case "$userName" in
    'Boimler')
        echo "Welcome Ensign. Safety Protocols engaged"
        ;;
    'Mariner')
        echo "Hey Beckett. Safety's off, just how you like it!"
        ;;
    'Rutherford')
        echo "Hi Rutherford. Safety protocols engaged...until Badgie says otherwise !"
        ;;
    'Tendi')
        echo "Hail, Mistress of the Winter Constellations !"
        ;;
    *)
        echo "Welcome to the holodeck, $userName"
        ;;
esac