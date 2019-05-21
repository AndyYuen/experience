[condition][location]There is a Scheduled Flight identified as {$scheduled}={$scheduled} : Flight(operational_status == "Scheduled")
[condition][location]- with operational_status {operational_status}=operational_status == {operational_status}
[condition][location]- with airline_code {airline_code}=airline_code == {airline_code}
[condition][location]- with flight_number {flight_number}=flight_number == {flight_number}
[condition][location]There is an Updated schedule for Flight {$scheduled} identified as {$updated}={$updated} : Flight(operational_status == "Planned", 
airline_code == {$scheduled}.airline_code, flight_number == {$scheduled}.flight_number)
[condition][location]- with operational_status {operational_status}=operational_status == {operational_status}
[condition][location]- with airline_code {airline_code}=airline_code == {airline_code}
[condition][location]- with fight_number {fight_number}=fight_number == {fight_number}
[condition][location]There is a Calculation Object identified as {$calc}={$calc} : Calculation(impactRating != "Unchanged")
[condition][location]There is a Disruption Object identified as {$disruption}={$disruption} : Disruption()
[condition][location]There is a Passenger Object identified as {$passenger}={$passenger} : Passenger()
[consequence][location]Log name of this rule=System.out.println("Executed Rule: " + drools.getRule().getName() );
[consequence][location]Remove Updated Flight identified as {$updated}=retract($updated);
[consequence][location]Calculate flight delay for Flight {$scheduled} with changed schedule {$updated} in Calculation Object=insert(new Calculation("Unchanged", 
{$scheduled}.airline_code, {$scheduled}.flight_number, 
toMinutes({$updated}.schedule_departure_local) - toMinutes({$scheduled}.schedule_departure_local)));
[consequence][location]Create Disruption Event based on Calculation Object=insert(Disruption($calc.impactRating, 
$calc.airlineCode, $calc.flightNumber,$calc.delayInMinutes));
[consequence][location]From info contained in Disruption Object {$disruption} retrieve Passenger List and submit top {number} most important passengers in the list=service.sendVipList({$disruption}.airlineCode + 
{$disruption}.flightNumber, {number});
[consequence][location]From info contained in Disruption Object {$disruption} retrieve Passenger List and call it {passengerList}=List {passengerList} = service.retrievePassengersFromRest( 
{$disruption}.flightNumber);
[consequence][location]Using Passenger list named {passengerList} retrieve Top {number} VIPs in a list and call it {topList}=List {topList} = service.getTopList( {passengerList}, {number});
[consequence][location]Using top VIP list named {topList} insert each VIP into working memory=for (Passenger topPassenger : {topList}) {\ninsert(topPassenger);\nSystem.out.println(topPassenger);\nSystem.out.println("-----------");\n};
[consequence][location]From info contained in Disruption Object {$disruption} and Passenger Object {$passenger} notify VIP identified=service.sendVip( {$disruption}.flightNumber, {$passenger});