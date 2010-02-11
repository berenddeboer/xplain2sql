database COMTECdatawarehouse.

base external id (A16).
base from (D).
base till (D).
base start (D).
base stop (D).
base distance (I9).
base order date (D).
base address kind (V80).
base product kind (V80).
base resource kind (V80).
base contact name (V80).
base resource name (V80).
base product name (V80).
base product description (V80).
base street name (V80).
base door number (V5).
base door number postfix (V20).
base zipcode (V10).
base city name (V50).
base country name (V50).
base amount (R6,4).
base unit code (A10).
base plan region (V80).
base plan group (V80).
base department  (V60).
base reference (V40).
base action name (V20) = "pickup", "delivery", "move", "pause", "wait", "obtain", "release".

type country (I9) = country name.

type city (I9) = city name, country.

type address (I9) =
  external id,
  address kind,
  street name, door number, door number postfix,
  zipcode, city,
  plan region, plan group.

type contact (I9) =
  external id, contact name.

# product description is either the product description in the user's language,
# or the overruled description.
type product (I9) =
  external id, 
  product description,
  product kind.

type order (I9) = 
  external id, 
  order date,
  contact, product,
  department, order_reference,
  pickup_from, pickup_till,
  delivery_from, delivery_till.

type order amount (I9) =
  order, amount, unit code.

type resource (I9) =
  external id,
  resource name,
  resource kind.


type trip (I9) = 
  external id.

type trip action (I9) =
  trip,
  planned_start, planned_stop, planned_distance,
  realized_start, realized_stop, realized_distance,
  action name.

type acquire (I9) =
  [trip action], resource.

type release (I9) =
  [trip action], resource.

type pickup (I9) =
  [trip action], order, pickup_reference.

type delivery (I9) =
  [trip action], order, delivery_reference.

type move (I9) =
  [trip action], address.

type pause (I9) =
  [trip action].

type wait (I9) =
  [trip action].


# copy active resource for every trip action
type trip action resources (I9) =
  trip action, resource.

type trip action contacts (I9) =
  trip action, contact.


# certain queries

# number of trip actions per trip

extend trip with `number of trip actions' =
  count trip action
  per trip.

# duration of a trip

extend trip with start date =
  min trip action its realized_start
  per trip.

extend trip with stop date =
  max trip action its realized_stop
  per trip.

extend trip with duration =
  stop date - start date.

get trip its duration.


# number of kilometers driven per trip.


# number of stops per trip
# hard, have to distinguish between addresses.

end.