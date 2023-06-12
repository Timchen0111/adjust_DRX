function received = active()
%If ti expired, state = 1. else, = 0
judge = packet(); %A boolean variable
if judge == true
    %clear buffer
    received = true;
else
    %nothing happened
    received = false;
end