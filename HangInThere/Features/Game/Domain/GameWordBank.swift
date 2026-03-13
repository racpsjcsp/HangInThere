//
//  GameWordBank.swift
//  HangInThere
//
//  Created by Codex on 12/03/26.
//

import Foundation

enum GameWordBank {
    static let wordsByCategoryAndLevel: [HangmanCategory: [GameLevel: [HangmanWord]]] = [
        .animals: exactLevelWords(easy: animalsEasy, medium: animalsMedium, hard: animalsHard),
        .geography: exactLevelWords(easy: geographyEasy, medium: geographyMedium, hard: geographyHard),
        .foods: exactLevelWords(easy: foodsEasy, medium: foodsMedium, hard: foodsHard),
        .objects: exactLevelWords(easy: objectsEasy, medium: objectsMedium, hard: objectsHard)
    ]

    private static let animalsEasy = wordList("""
    Lion|Big cat known for its mane
    Tiger|Striped big cat
    Elephant|Largest land animal with a trunk
    Giraffe|Tall animal with a long neck
    Monkey|Primate that climbs and swings
    Rabbit|Small animal with long ears
    Dolphin|Smart marine mammal
    Penguin|Flightless bird from cold regions
    Zebra|Animal with black and white stripes
    Panda|Black and white bear that eats bamboo
    Koala|Tree-dwelling Australian marsupial
    Otter|Playful swimmer with dense fur
    Falcon|Fast bird of prey
    Parrot|Colorful bird that mimics sounds
    Leopard|Spotted wild cat
    Panther|Large dark-coated wild cat
    Buffalo|Large horned mammal
    Hamster|Small pet with cheek pouches
    Peacock|Bird with a bright fan tail
    Cheetah|Fastest land animal
    Seal|Marine mammal that rests on shore
    Walrus|Large marine mammal with tusks
    Raccoon|Masked mammal with nimble paws
    Flamingo|Pink bird that stands on one leg
    Kangaroo|Australian jumper with a pouch
    Dog|Popular domestic pet
    Cat|Domestic pet with whiskers
    Horse|Animal often used for riding
    Sheep|Farm animal with wool
    Goat|Farm animal with horns
    Cow|Farm animal raised for milk
    Pig|Farm animal with a snout
    Chicken|Common farm bird
    Duck|Water bird with a broad bill
    Goose|Large water bird with a long neck
    Turkey|Large farm bird often served at holidays
    Donkey|Sturdy animal related to horses
    Fox|Clever wild animal with a bushy tail
    Wolf|Wild canine that lives in packs
    Deer|Hoofed animal with antlers
    Moose|Large deer with broad antlers
    Elk|Large deer found in forests and plains
    Bear|Large mammal with strong claws
    Polar Bear|White bear from the Arctic
    Brown Bear|Large bear found in forests and mountains
    Squirrel|Tree climber that stores nuts
    Chipmunk|Small striped relative of the squirrel
    Hedgehog|Small spiny mammal
    Mole|Burrowing animal with strong front paws
    Bat|Only mammal that truly flies
    Beaver|Builder of dams and lodges
    Bison|Massive shaggy grazer
    Camel|Desert animal with humps
    Llama|South American pack animal
    Alpaca|Woolly relative of the llama
    Hippo|Huge river mammal
    Rhino|Large animal with one or two horns
    Gorilla|Largest living primate
    Chimpanzee|Primate closely related to humans
    Lemur|Primate native to Madagascar
    Sloth|Slow tree-dwelling mammal
    Antelope|Fast hoofed grazer
    Reindeer|Cold-weather deer with antlers
    Skunk|Animal known for its strong spray
    Badger|Burrowing mammal with a striped face
    Weasel|Long slender hunting mammal
    Ferret|Domestic relative of the weasel
    Porcupine|Rodent covered in quills
    Armadillo|Mammal with an armored shell
    Possum|Tree-climbing marsupial
    Crocodile|Large reptile with powerful jaws
    Alligator|Broad-snouted reptile from swamps
    Turtle|Reptile with a shell
    Tortoise|Land-dwelling shell reptile
    Frog|Jumping amphibian
    Toad|Amphibian with dry bumpy skin
    Salmon|Fish that swims upstream to spawn
    Trout|Freshwater fish popular with anglers
    Shark|Powerful ocean predator
    Whale|Massive marine mammal
    Orca|Black and white ocean hunter
    Octopus|Sea animal with eight arms
    Squid|Sea animal with tentacles
    Lobster|Sea creature with claws
    Crab|Shellfish that walks sideways
    Jellyfish|Soft-bodied drifter with tentacles
    Seahorse|Tiny fish with a curled tail
    Starfish|Sea creature with radiating arms
    Eagle|Large bird of prey
    Owl|Bird known for night hunting
    Swan|Graceful white water bird
    Pelican|Bird with a large throat pouch
    Robin|Small bird with a red chest
    Sparrow|Common small brown bird
    Crow|Smart black bird
    Hawk|Sharp-eyed hunting bird
    Heron|Long-legged wading bird
    Rooster|Male chicken with a crest
    Bee|Insect that makes honey
    Butterfly|Colorful winged insect
    """, difficulty: 1)

    private static let geographyEasy = wordList("""
    Canada|Large country north of the United States
    Brazil|Largest country in South America
    Mexico|Country south of the United States
    France|European country known for Paris
    Germany|European country known for Berlin
    Italy|European country with Rome and Venice
    Spain|European country on the Iberian Peninsula
    Portugal|Country on the western edge of Europe
    Japan|Island nation in East Asia
    China|Large country in East Asia
    India|Large country in South Asia
    Australia|Country and continent in the Southern Hemisphere
    Russia|Largest country in the world
    Egypt|Country known for pyramids and the Nile
    Greece|Country with many ancient ruins and islands
    Turkey|Country spanning Europe and Asia
    Argentina|Large country in South America
    Chile|Long narrow country on South America's west coast
    Peru|Country home to Machu Picchu
    Colombia|Country in northern South America
    Norway|Nordic country with deep fjords
    Sweden|Nordic country in northern Europe
    Finland|Northern European country known for lakes
    Iceland|Volcanic island nation in the North Atlantic
    Ireland|Island country west of Great Britain
    Scotland|Country in the northern part of Great Britain
    England|Largest country in the United Kingdom
    Wales|Country on the western side of Great Britain
    Poland|Central European country
    Ukraine|Large country in Eastern Europe
    Kenya|East African country with famous wildlife reserves
    Nigeria|Most populous country in Africa
    Morocco|North African country near the Strait of Gibraltar
    Thailand|Southeast Asian country known for beaches and temples
    Vietnam|Southeast Asian country along the South China Sea
    Indonesia|Large island nation in Southeast Asia
    Philippines|Archipelago in Southeast Asia
    New Zealand|Island country southeast of Australia
    Alaska|Largest state of the United States
    Texas|Large state in the southern United States
    California|Pacific coast state in the United States
    Florida|Warm southeastern U.S. state with many beaches
    Hawaii|Pacific island state of the United States
    Amazon|Great river and rainforest in South America
    Nile|Famous river in northeastern Africa
    Sahara|Vast desert in North Africa
    Arctic|Region around the North Pole
    Antarctica|Frozen continent at the South Pole
    Everest|Highest mountain above sea level
    Alps|Mountain range in Europe
    Andes|Long mountain chain in South America
    Rockies|Major mountain range in North America
    Himalayas|Mountain range containing Everest
    Pacific Ocean|Largest ocean on Earth
    Atlantic Ocean|Ocean between the Americas and Europe
    Indian Ocean|Ocean south of Asia
    Caribbean Sea|Warm sea with many islands
    Mediterranean Sea|Sea between Europe and Africa
    Black Sea|Sea bordered by Eastern Europe and Western Asia
    Red Sea|Sea between Africa and Arabia
    Greenland|World's largest island
    Bali|Popular Indonesian island
    Cuba|Large Caribbean island nation
    Jamaica|Caribbean island nation known for reggae
    Paris|Capital of France
    London|Capital of the United Kingdom
    Rome|Capital of Italy
    Madrid|Capital of Spain
    Berlin|Capital of Germany
    Tokyo|Capital of Japan
    Seoul|Capital of South Korea
    Sydney|Australian city known for its opera house
    Dubai|City known for skyscrapers in the UAE
    Cairo|Capital of Egypt
    Athens|Capital of Greece
    Venice|Italian city built on canals
    Barcelona|Spanish city on the Mediterranean coast
    Prague|Capital of the Czech Republic
    Amsterdam|Capital of the Netherlands
    Brussels|Capital of Belgium
    Zurich|Major city in Switzerland
    Oslo|Capital of Norway
    Stockholm|Capital of Sweden
    Helsinki|Capital of Finland
    Copenhagen|Capital of Denmark
    Beijing|Capital of China
    Shanghai|Major port city in China
    Kyoto|Historic city in Japan
    Delhi|Major city in northern India
    Mumbai|Coastal city in western India
    Nepal|Country in the Himalayas
    Grand Canyon|Large canyon carved by the Colorado River
    Niagara Falls|Famous waterfalls on the U.S.-Canada border
    Yosemite|National park in California
    Sicily|Large island off southern Italy
    Maldives|Island nation in the Indian Ocean
    Istanbul|Major city straddling Europe and Asia
    Suez Canal|Waterway linking the Mediterranean and Red Sea
    Panama Canal|Waterway linking the Atlantic and Pacific
    Mount Fuji|Famous volcano in Japan
    """, difficulty: 1)

    private static let animalsMedium = wordList("""
    Axolotl|Salamander known for keeping its feathery gills
    Barracuda|Fast predatory fish with a long body
    Caracal|Wild cat with tall black ear tufts
    Dromedary|Camel with a single hump
    Echidna|Spiny egg-laying mammal
    Ibex|Wild mountain goat with curved horns
    Jackrabbit|Large hare built for speed
    Manatee|Gentle marine mammal called a sea cow
    Narwhal|Arctic whale with a long tusk
    Ocelot|Spotted cat from the Americas
    Red Panda|Tree-dwelling mammal with a ringed tail
    Eland|Large African antelope
    Bonobo|Great ape closely related to chimpanzees
    Capybara|Largest rodent in the world
    Emu|Large flightless bird from Australia
    Fennec|Small fox with oversized ears
    Ibis|Wading bird with a curved bill
    Orca|Ocean predator also called a killer whale
    Albatross|Ocean bird with an enormous wingspan
    Impala|Graceful antelope known for leaping
    Moorhen|Wetland bird with large feet
    Nighthawk|Bird active at dusk
    Osprey|Fish-hunting bird of prey
    Rhea|Large South American flightless bird
    Peacock Spider|Tiny spider known for colorful courtship displays
    Snow Leopard|Mountain cat with a thick spotted coat
    Meerkat|Small social mammal that stands upright
    Wolverine|Powerful member of the weasel family
    Lynx|Wild cat with tufted ears
    Puma|Large cat also called a cougar
    Gazelle|Fast antelope of Africa and Asia
    Mantis Shrimp|Sea creature with striking colorful eyes
    Blue Jay|Bold blue songbird
    Kingfisher|Bird that dives for fish
    Toucan|Bird with a large colorful bill
    Macaw|Large bright parrot
    Pelican Eel|Deep-sea fish with a huge mouth
    Hammerhead|Shark with a wide hammer-shaped head
    Swordfish|Large fast fish with a pointed bill
    Manta Ray|Giant ray with winglike fins
    Sea Otter|Marine mammal that floats on its back
    Musk Ox|Arctic grazer with shaggy fur
    Pronghorn|North American runner with horns
    Kookaburra|Australian bird known for its laughlike call
    Roadrunner|Fast-running desert bird
    Tortoiseshell Cat|Domestic cat with mottled fur coloring
    Pufferfish|Fish that inflates into a ball
    Swordtail|Freshwater fish with an extended tail fin
    Blue Whale|Largest animal on Earth
    Humpback Whale|Whale famous for breaching and songs
    Sea Lion|Marine mammal with visible ear flaps
    Gopher|Burrowing rodent
    Wombat|Sturdy Australian marsupial
    Kiwi|Small flightless bird from New Zealand
    Cormorant|Diving bird that dries its wings in the sun
    Hornbill|Bird with a large curved bill
    Sandpiper|Shorebird that runs along beaches
    Stingray|Flat fish with a barbed tail
    Moray Eel|Eel that hides in rocky reefs
    Sword-billed Hummingbird|Bird with an extremely long bill
    Musk Deer|Deer-like animal without antlers
    Ringtail Lemur|Lemur with a striped tail
    Howler Monkey|Monkey known for loud calls
    Mandrill|Colorful primate with a bright face
    Baboon|Ground-dwelling primate
    Vulture|Bird that feeds mostly on carrion
    Harrier|Slim hawk that glides low over fields
    Kestrel|Small hovering falcon
    Gannet|Seabird that plunges into water
    Pheasant|Long-tailed ground bird
    Ptarmigan|Bird that changes color with the seasons
    Groundhog|Rodent also called a woodchuck
    Marmot|Large burrowing squirrel
    Chinchilla|Soft-furred rodent from the Andes
    Mink|Small semi-aquatic mustelid
    Marten|Forest-dwelling relative of the weasel
    Tapir|Large browsing mammal with a short snout
    Coati|Raccoon relative with a long nose
    Serval|Long-legged African wild cat
    Addax|Desert antelope with twisted horns
    Springbok|Leaping antelope from southern Africa
    Guanaco|Wild camelid from South America
    Tree Frog|Frog adapted for climbing
    Bullfrog|Large frog with a deep croak
    Gecko|Lizard that can climb walls
    Iguana|Large herbivorous lizard
    Komodo Dragon|Giant monitor lizard
    King Cobra|Longest venomous snake
    Python|Large constricting snake
    Coral Snake|Brightly banded venomous snake
    Mackerel|Fast-swimming ocean fish
    Snapper|Popular reef fish
    Swordtail Butterfly|Butterfly with long taillike wings
    Dragonfly|Insect with large eyes and strong flight
    Grasshopper|Jumping insect with long hind legs
    Firefly|Insect known for glowing at night
    Tarantula|Large hairy spider
    Hermit Crab|Crab that lives in borrowed shells
    Sea Cucumber|Soft marine animal on the ocean floor
    Secretary Bird|Tall African bird that hunts snakes on foot
    """, difficulty: 2)

    private static let geographyMedium = wordList("""
    Archipelago|Chain or cluster of islands
    Atacama Desert|Extremely dry desert in South America
    Baffin Island|Large Arctic island in Canada
    Cape Horn|Headland near South America's southern tip
    Faroe Islands|North Atlantic islands between Iceland and Norway
    Gobi Desert|Cold desert spanning Mongolia and China
    Ha Long Bay|Vietnamese bay known for limestone pillars
    Iberian Peninsula|Landmass containing Spain and Portugal
    Kalahari|Dry region in southern Africa
    Lake Baikal|Deep freshwater lake in Siberia
    Mekong Delta|Rich river delta in Vietnam
    Namib Desert|Coastal desert with giant dunes
    Rift Valley|Long tectonic trench in East Africa
    Ural Mountains|Range often marking part of Europe and Asia
    Yangtze River|Longest river in Asia
    Aegean Sea|Sea between Greece and Turkey
    Balkan Peninsula|Peninsula in southeastern Europe
    Caspian Sea|World's largest inland body of water
    Galapagos|Pacific islands linked to evolution studies
    Yucatan Peninsula|Region between the Gulf of Mexico and Caribbean
    Zambezi River|River flowing over Victoria Falls
    Bering Strait|Waterway between Alaska and Russia
    Euphrates|Historic river of Mesopotamia
    Hudson Bay|Vast inland sea in Canada
    Isthmus of Panama|Narrow land bridge joining two continents
    Pyrenees|Mountain range between Spain and France
    Red Sea|Sea between northeast Africa and Arabia
    Tasman Sea|Sea between Australia and New Zealand
    Aral Sea|Shrinking lake between Kazakhstan and Uzbekistan
    Dead Sea|Very salty lake in the Middle East
    English Channel|Waterway between England and France
    Olympic Peninsula|Peninsula in Washington State
    Po Valley|Fertile plain in northern Italy
    Yellow Sea|Sea between China and the Korean Peninsula
    Great Lakes|Five large freshwater lakes in North America
    Mojave Desert|Desert in the southwestern United States
    Gulf of Mexico|Large gulf bordered by the U.S. and Mexico
    Appalachians|Old mountain range in the eastern U.S.
    Cascades|Volcanic mountain chain in the Pacific Northwest
    Danube River|Major European river flowing to the Black Sea
    Loire Valley|French region known for riverside castles
    Bavaria|Region in southern Germany
    Transylvania|Romanian region surrounded by mountains
    Patagonia|Region shared by Argentina and Chile
    Serengeti|East African plain known for migration
    Kilimanjaro|Highest mountain in Africa
    Lake Titicaca|High-altitude lake in the Andes
    Machu Picchu|Historic mountain site in Peru
    Patagonian Andes|Southern section of the Andes
    Sundarbans|Mangrove forest region in South Asia
    Borneo|Large island in Southeast Asia
    Tasmania|Island state south of mainland Australia
    Seychelles|Island nation in the Indian Ocean
    Canary Islands|Spanish islands off northwest Africa
    Azores|Portuguese islands in the Atlantic
    Fiji|Island country in the South Pacific
    Mongolia|Landlocked country between Russia and China
    Botswana|Southern African country with the Okavango Delta
    Namibia|Country on Africa's southwest coast
    Bolivia|Landlocked South American country
    Paraguay|Landlocked country in South America
    Uruguay|Country between Brazil and Argentina
    Slovenia|Central European country with Alpine scenery
    Croatia|Country along the Adriatic Sea
    Bulgaria|Country on the Balkan Peninsula
    Romania|Eastern European country on the Black Sea
    Georgia|Country in the Caucasus region
    Armenia|Mountainous country in the South Caucasus
    Azerbaijan|Country on the Caspian Sea
    Kazakhstan|Large Central Asian country
    Uzbekistan|Central Asian country with Silk Road cities
    Kyrgyzstan|Mountainous country in Central Asia
    Tajikistan|Central Asian country with high peaks
    Bhutan|Himalayan kingdom between India and China
    Laos|Landlocked country in Southeast Asia
    Cambodia|Country home to Angkor Wat
    Myanmar|Country west of Thailand
    Sri Lanka|Island nation south of India
    Madagascar|Large island off Africa's southeast coast
    Greenwich|District in London used for prime meridian reference
    Sicilian Strait|Sea passage near southern Italy
    Biscay Bay|Bay on the western coast of France and Spain
    Aconcagua|Highest mountain in South America
    Denali|Highest peak in North America
    Marrakesh|Historic city in Morocco
    Alexandria|Mediterranean city in Egypt
    Reykjavik|Capital of Iceland
    Valencia|Spanish city on the Mediterranean
    Naples|Italian city near Mount Vesuvius
    Munich|Major city in southern Germany
    Lisbon|Capital of Portugal
    Buenos Aires|Capital of Argentina
    Santiago|Capital of Chile
    Lima|Capital of Peru
    Bogota|Capital of Colombia
    Casablanca|Major coastal city in Morocco
    Phuket|Thai island destination
    Queensland|State in northeastern Australia
    Bavarian Forest|Wooded region in southeastern Germany
    Adriatic Coast|Coastline along the Adriatic Sea
    """, difficulty: 2)

    private static let foodsMedium = wordList("""
    Chilaquiles|Mexican dish of tortilla chips simmered in salsa
    Feijoada|Brazilian black bean stew with pork
    Gnocchi|Italian dumplings often made from potato
    Halloumi|Brined cheese that grills well
    Jambalaya|Rice dish with Cajun and Creole roots
    Laksa|Southeast Asian noodle soup with rich broth
    Moussaka|Layered casserole with eggplant and meat
    Ratatouille|Stewed vegetable dish from southern France
    Shakshuka|Eggs poached in spiced tomato sauce
    Tamales|Corn dough parcels steamed in husks
    Vindaloo|Spicy curry with Goan roots
    Yorkshire Pudding|Baked batter served with roast meals
    Bibimbap|Korean rice bowl with mixed toppings
    Focaccia|Italian flat oven-baked bread
    Harissa|North African chili paste
    Dashi|Japanese stock made from kombu and bonito
    Farfalle|Bow-tie shaped pasta
    Huevos Rancheros|Egg dish with tortillas and salsa
    Nasi Goreng|Indonesian fried rice
    Tonkotsu|Pork-bone broth style of ramen
    Yakitori|Japanese grilled chicken skewers
    Baklava|Layered pastry with nuts and syrup
    Frittata|Italian open-faced egg dish
    Goulash|Paprika-rich stew from Central Europe
    Jollof Rice|West African tomato rice dish
    Nasi Lemak|Coconut rice dish from Malaysia
    Pozole|Mexican hominy soup
    Spanakopita|Greek spinach and feta pastry
    Tabbouleh|Herb-heavy salad with bulgur
    Arepas|Corn cakes from northern South America
    Biryani|Layered rice dish with spices
    Empanada|Stuffed pastry baked or fried
    Paella|Spanish rice dish cooked in a wide pan
    Risotto|Creamy Italian rice dish
    Fondue|Melted cheese dish for dipping bread
    Bruschetta|Toasted bread topped with tomato or other toppings
    Gazpacho|Chilled tomato soup from Spain
    Pierogi|Filled dumplings from Central and Eastern Europe
    Schnitzel|Thin breaded cutlet
    Tiramisu|Italian dessert layered with cream and coffee flavors
    Ravioli|Stuffed pasta parcels
    Calzone|Folded pizza dough filled before baking
    Gumbo|Louisiana stew thickened with roux or okra
    Couscous|Tiny steamed semolina grains
    Polenta|Cooked cornmeal dish
    Fajitas|Sizzling skillet dish with tortillas
    Tempura|Japanese battered and fried seafood or vegetables
    Pho|Vietnamese noodle soup
    Bao Buns|Soft steamed buns
    Falafel|Fried chickpea patties
    Kimchi Fried Rice|Rice stir-fried with fermented vegetables
    Satay|Skewered meat served with sauce
    Miso Soup|Japanese soup with fermented soybean paste
    Poke Bowl|Bowl of rice topped with marinated fish
    Chow Mein|Stir-fried noodle dish
    Pad Thai|Thai stir-fried rice noodle dish
    Massaman Curry|Thai curry with warm spices
    Butter Chicken|Creamy tomato-based Indian curry
    Samosa|Fried pastry with savory filling
    Korma|Rich curry thickened with yogurt or nuts
    Banh Mi|Vietnamese sandwich in a crusty roll
    Cassoulet|Slow-cooked bean casserole
    Paella Negra|Seafood rice dish tinted with squid ink
    Croque Monsieur|French grilled ham and cheese sandwich
    Gyoza|Japanese pan-fried dumplings
    Bibingka|Filipino baked rice cake
    Cordon Bleu|Breaded meat stuffed with ham and cheese
    Potstickers|Dumplings crisped on one side
    Minestrone|Italian vegetable soup
    Cannelloni|Tube pasta stuffed and baked
    Caprese Salad|Tomato, mozzarella, and basil salad
    Chicken Tikka|Marinated grilled chicken pieces
    Tzatziki|Yogurt-cucumber sauce from Greece
    Bratwurst|German sausage often grilled
    Pastrami Sandwich|Seasoned smoked beef sandwich
    Sauerbraten|German pot roast in tangy gravy
    Pavlova|Meringue dessert with fruit topping
    Shepherd Pie|Pie topped with mashed potatoes
    Rogan Josh|Aromatic curry with red sauce
    Chowder|Rich chunky soup
    Mofongo|Mashed plantain dish from Puerto Rico
    Ceviche|Seafood cured in citrus
    Antipasto|Italian starter platter
    Coq au Vin|Chicken braised with wine
    Bangers and Mash|Sausages served with mashed potatoes
    Lentil Soup|Hearty soup made with lentils
    Baked Ziti|Oven-baked pasta with sauce and cheese
    Chicken Parmesan|Breaded chicken with tomato sauce and cheese
    Molletes|Open-faced Mexican bean and cheese bread
    Pupusa|Stuffed griddled flatbread from El Salvador
    Kebab|Seasoned meat cooked on a skewer
    Baozi|Chinese filled steamed buns
    Mochi Ice Cream|Ice cream wrapped in sweet rice dough
    French Onion Soup|Soup topped with bread and melted cheese
    Tteokguk|Korean soup with sliced rice cakes
    Aloo Gobi|Indian potato and cauliflower dish
    Scallion Pancake|Savory layered flatbread
    Chicken Katsu|Breaded fried chicken cutlet
    Gingerbread|Spiced baked treat made with molasses
    Stuffed Peppers|Peppers filled with rice, meat, or vegetables
    """, difficulty: 2)

    private static let objectsMedium = wordList("""
    Barometer|Device that measures air pressure
    Caliper|Tool used to measure thickness or diameter
    Decanter|Vessel used for pouring and aerating liquids
    Incubator|Enclosed apparatus that provides controlled warmth
    Kiln|High-temperature oven for ceramics
    Trestle|Support framework for a table or structure
    Xylophone|Percussion instrument with wooden bars
    Blowtorch|Tool that produces a focused flame
    Drafting Compass|Tool used to draw circles
    Haversack|Bag carried over the shoulder
    Kaleidoscope|Tube that creates mirrored patterns
    Monocle|Single lens worn over one eye
    Nozzle|Attachment that controls fluid flow
    Odometer|Device that records traveled distance
    Ratchet|Mechanism that moves in one direction
    Scabbard|Protective sheath for a blade
    Thimble|Protective cap worn while sewing
    Abacus|Manual counting frame with beads
    Carabiner|Spring-loaded metal clip
    Easel|Stand used for a canvas
    Jigsaw|Tool with a rapidly moving blade
    Mortar and Pestle|Tool used for grinding ingredients
    Pulley|Wheel mechanism used to lift loads
    Quill Pen|Writing instrument made from a feather shaft
    Rasp|Coarse file for shaping
    Soldering Iron|Tool used to melt solder
    Turntable|Rotating platform for records
    Vise|Bench-mounted clamping tool
    Whetstone|Stone used to sharpen blades
    Xacto Knife|Precision cutting knife
    Clamp|Device that holds items tightly together
    Hinge|Joint that lets a panel swing
    Inkwell|Container for storing ink
    Javelin|Long spear-like sports implement
    Kerosene Lamp|Lamp fueled by kerosene
    Latch|Fastener that keeps something closed
    Quadcopter|Aircraft lifted by four rotors
    Trivet|Stand protecting surfaces from hot items
    Utility Knife|Retractable cutting tool
    Whisk|Kitchen tool for mixing
    Binoculars|Optical tool for distant viewing
    Tripod|Three-legged stand for support
    Compass|Instrument for finding direction
    Thermos|Insulated container for drinks
    Whiteboard|Smooth board written on with dry markers
    Projector|Device that casts an image onto a wall
    Calculator|Device used for arithmetic
    Drill|Tool that bores holes
    Sawhorse|Support stand for boards or projects
    Toolkit|Box or bag for storing tools
    Colander|Bowl with holes for draining water
    Rolling Pin|Cylinder used to flatten dough
    Cutting Board|Board used while chopping food
    Can Opener|Tool used to open cans
    Tongs|Tool used to grip hot items
    Ladle|Deep spoon for serving soup
    Peeler|Tool used to remove vegetable skins
    Grater|Tool used to shred food
    Measuring Cup|Cup marked for volume
    Measuring Spoon|Spoon marked for small volumes
    Shovel|Tool used for digging
    Rake|Tool used to gather leaves or soil
    Wheelbarrow|One-wheeled container for hauling loads
    Hose|Flexible tube for carrying water
    Lantern|Portable enclosed light
    Padlock|Lock used with a key or code
    Doorknob|Handle used to open a door
    Coat Hanger|Hooked item used to hold clothes
    Booksend|Object that keeps books upright
    Paperweight|Weighted object used to hold papers
    Sticky Notes|Small adhesive paper notes
    Highlighter|Marker used to emphasize text
    Hole Punch|Tool that punches paper holes
    Paper Cutter|Tool for slicing paper cleanly
    Staple Remover|Tool used to pull staples out
    Magnifying Glass|Lens used to enlarge what you see
    Telescope|Instrument used to view distant objects
    Microscope|Instrument used to enlarge tiny objects
    Alarm Clock|Clock that makes a sound at a set time
    Doorbell|Device that rings at an entrance
    Power Bank|Portable battery pack
    Webcam|Camera used with a computer
    Joystick|Control stick used in games or machinery
    Game Console|Device used to play video games
    Chalkboard|Board written on with chalk
    Filing Cabinet|Cabinet used to store files
    Clipboard Folder|Board and cover for holding papers
    Shop Vacuum|Heavy-duty vacuum for workshops
    Extension Cord|Long cable that extends power access
    Surge Protector|Power strip that guards electronics
    Heat Gun|Tool that blows very hot air
    Paint Roller|Tool used to spread paint
    Level Tool|Tool used to check if something is straight
    Stud Finder|Tool used to locate wall studs
    Tape Measure|Flexible measuring strip
    Garden Shears|Tool used to trim plants
    Squeegee|Tool used to wipe smooth surfaces
    Mail Slot|Opening used to receive letters
    Hourglass|Device that measures time with sand
    Pocketknife|Small folding knife carried in a pocket
    """, difficulty: 2)

    private static let foodsEasy = wordList("""
    Pizza|Baked dough topped with sauce and cheese
    Burger|Sandwich with a patty in a bun
    Pasta|Italian noodles served with sauce
    Taco|Folded tortilla filled with meat or vegetables
    Sushi|Japanese dish built around seasoned rice
    Burrito|Filled tortilla rolled into a wrap
    Pancake|Flat breakfast cake cooked on a griddle
    Waffle|Grid-pattern breakfast cake
    Cookie|Small baked sweet treat
    Muffin|Individual baked quick bread
    Lasagna|Layered baked pasta dish
    Omelette|Egg dish folded around a filling
    Noodles|Long strips of cooked dough
    Pretzel|Twisted baked bread
    Popcorn|Puffed corn snack
    Brownie|Dense chocolate dessert bar
    Donut|Fried ring-shaped pastry
    Sandwich|Filling placed between slices of bread
    Cupcake|Small frosted cake
    Hotdog|Sausage served inside a bun
    Meatball|Seasoned ball of ground meat
    Dumpling|Small piece of filled or plain dough
    Smoothie|Blended cold drink
    Cereal|Breakfast grains served in a bowl
    Sausage|Seasoned ground meat in a casing
    Salad|Dish of mixed greens or vegetables
    Soup|Warm liquid dish served in a bowl
    Steak|Cut of beef cooked whole
    Rice|Grain served as a staple food
    Fries|Thin fried potato strips
    Nachos|Tortilla chips topped with cheese
    Toast|Sliced bread browned by heat
    Bagel|Ring-shaped chewy bread
    Biscuit|Soft baked bread or cookie
    Croissant|Flaky crescent-shaped pastry
    Pie|Baked crust with sweet or savory filling
    Cake|Sweet baked dessert
    Ice Cream|Frozen sweet dessert
    Milkshake|Cold blended drink with ice cream
    Pudding|Soft spoonable dessert
    Cheesecake|Creamy dessert with a crust
    Apple Pie|Pie filled with apples and spice
    Mashed Potatoes|Soft potatoes whipped with butter
    Fried Rice|Rice stir-fried with vegetables or meat
    Spaghetti|Long thin pasta
    Ramen|Noodle soup from Japan
    Macaroni|Small curved pasta
    Meatloaf|Baked loaf of seasoned ground meat
    Quesadilla|Folded tortilla with melted cheese
    Enchilada|Rolled tortilla covered in sauce
    Chili|Hearty spicy stew
    Oatmeal|Cooked hot cereal made from oats
    Yogurt|Cultured dairy food
    Granola|Crunchy mix of oats and nuts
    Porridge|Hot soft cereal dish
    Fruit Salad|Mixed fresh fruit dish
    Popsicle|Frozen treat on a stick
    Scrambled Eggs|Eggs stirred while cooking
    French Toast|Bread dipped in egg and fried
    Pot Roast|Slow-cooked beef roast
    Chicken Wings|Small seasoned chicken pieces
    Chicken Soup|Soup made with chicken broth
    Grilled Cheese|Toasted sandwich with melted cheese
    Onion Rings|Breaded fried onion slices
    Garlic Bread|Bread flavored with garlic and butter
    Spring Rolls|Rolled snacks with vegetables or meat
    Fried Chicken|Chicken coated and deep-fried
    Tomato Soup|Soup made from tomatoes
    Potato Salad|Cold dish of potatoes and dressing
    Coleslaw|Shredded cabbage salad
    Guacamole|Mashed avocado dip
    Hummus|Chickpea spread
    Tortilla|Flatbread used in many dishes
    Bacon|Cured slices of pork
    Jerky|Dried seasoned meat
    Cheddar|Popular firm cheese
    Pasta Salad|Cold pasta mixed with vegetables
    Cornbread|Quick bread made with cornmeal
    Pancetta|Italian cured pork belly
    Tuna Melt|Toasted sandwich with tuna and cheese
    Sloppy Joe|Saucy meat sandwich
    Fish Sticks|Breaded frozen fish pieces
    Chicken Salad|Cold salad with chopped chicken
    Stuffing|Seasoned bread side dish
    Biscuits and Gravy|Southern dish with soft biscuits
    Hash Browns|Shredded fried potatoes
    Tater Tots|Small crispy potato bites
    Clam Chowder|Creamy soup with clams
    Pita Bread|Round pocket flatbread
    Blueberry Muffin|Muffin filled with blueberries
    Peanut Butter|Creamy spread made from peanuts
    Jam Toast|Toast topped with fruit jam
    Trail Mix|Snack mix with nuts and dried fruit
    Chicken Sandwich|Sandwich built with chicken
    Rice Pudding|Sweet pudding made with rice
    Custard|Smooth dessert thickened with egg
    Corn Dog|Hot dog coated in corn batter
    Cheese Pizza|Pizza topped mainly with cheese
    Veggie Wrap|Soft wrap filled with vegetables
    Chicken Nuggets|Breaded bite-sized chicken pieces
    """, difficulty: 1)

    private static let objectsEasy = wordList("""
    Laptop|Portable personal computer
    Backpack|Bag carried on the back
    Pencil|Writing tool with graphite
    Helmet|Protective gear worn on the head
    Blanket|Soft cover used for warmth
    Wallet|Small case for cash and cards
    Mirror|Reflective surface
    Camera|Device used to take photos
    Scissors|Tool used for cutting
    Toaster|Appliance that browns bread
    Pillow|Soft support for resting the head
    Kettle|Container used to boil water
    Remote|Handheld device that controls electronics
    Bicycle|Two-wheeled vehicle powered by pedaling
    Suitcase|Luggage used for travel
    Notebook|Book for writing notes
    Headphones|Audio device worn over the ears
    Flashlight|Portable electric light
    Umbrella|Foldable cover used in rain
    Keyboard|Set of keys used for typing
    Charger|Device used to refill a battery
    Microwave|Appliance used to heat food quickly
    Sofa|Long cushioned seat
    Towel|Cloth used for drying
    Clock|Device that shows time
    Phone|Portable communication device
    Tablet|Flat touchscreen computer
    Television|Screen used to watch video
    Radio|Device that receives audio broadcasts
    Lamp|Object that gives light
    Chair|Seat for one person
    Desk|Table used for work or study
    Table|Furniture with a flat top
    Bookshelf|Shelves used to hold books
    Door|Panel used to enter a room
    Window|Opening with glass in a wall
    Curtain|Fabric hung over a window
    Rug|Piece of fabric placed on the floor
    Carpet|Soft floor covering
    Stool|Simple seat without a back
    Brush|Tool with bristles
    Comb|Tool used to untangle hair
    Toothbrush|Brush used to clean teeth
    Mug|Cup with a handle
    Plate|Flat dish for serving food
    Spoon|Utensil used for scooping
    Fork|Utensil with prongs
    Knife|Tool with a sharp blade
    Bowl|Round deep dish
    Pan|Shallow cooking vessel
    Pot|Deep cooking vessel
    Bottle|Container for drinks
    Cup|Small drinking vessel
    Glasses|Frames with lenses for vision
    Watch|Timepiece worn on the wrist
    Ring|Small band worn on a finger
    Necklace|Jewelry worn around the neck
    Bracelet|Jewelry worn around the wrist
    Belt|Strap worn around the waist
    Shoes|Footwear worn outdoors
    Sneakers|Soft athletic shoes
    Sandals|Open footwear
    Jacket|Outerwear worn on the upper body
    Coat|Warm outer garment
    Sweater|Knitted top for warmth
    Hat|Head covering
    Cap|Soft hat with a brim
    Gloves|Coverings for the hands
    Scarf|Long cloth worn around the neck
    Socks|Cloth coverings for the feet
    Purse|Small bag for personal items
    Keychain|Holder for keys
    Vacuum|Machine used to clean floors
    Blender|Appliance used to mix food
    Toothpaste|Paste used while brushing teeth
    Soap|Cleaning bar or liquid
    Shampoo|Liquid used to wash hair
    Battery|Object that stores electrical power
    Router|Device that shares internet access
    Mouse|Hand device used with a computer
    Monitor|Screen connected to a computer
    Speaker|Device that produces sound
    Fan|Device that moves air
    Stapler|Office tool used to fasten papers
    Tape|Sticky strip used to hold things
    Marker|Pen with bold ink
    Crayon|Colored wax drawing stick
    Eraser|Rubber used to remove pencil marks
    Ruler|Straight measuring tool
    Binder|Cover used to hold papers
    Clipboard|Board used to hold sheets of paper
    Ladder|Steps used to reach high places
    Bucket|Open container with a handle
    Mop|Tool used to clean floors
    Broom|Tool used for sweeping
    Trash Can|Container for waste
    Air Fryer|Countertop cooker that uses hot air
    Whisk|Kitchen tool for mixing
    Printer|Machine that puts text on paper
    Hammer|Tool used for driving nails
    """, difficulty: 1)

    private static let animalsHard = wordList("""
    Lion|Big cat often called the king of the jungle
    Tiger|Striped big cat
    Elephant|Largest land animal with a trunk
    Giraffe|Tall animal with a very long neck
    Monkey|Primate known for climbing and swinging
    Rabbit|Small mammal with long ears
    Dolphin|Intelligent marine mammal
    Penguin|Flightless bird that lives in cold regions
    Zebra|Animal with black-and-white stripes
    Panda|Black-and-white bear that eats bamboo
    Koala|Australian animal that lives in eucalyptus trees
    Otter|Playful animal that swims in rivers and seas
    Falcon|Fast bird of prey
    Parrot|Colorful bird that can mimic sounds
    Leopard|Spotted big cat
    Panther|Large wild cat with a dark coat
    Buffalo|Large horned mammal
    Hamster|Small furry pet with cheek pouches
    Peacock|Bird famous for its colorful tail feathers
    Cheetah|Fastest land animal
    Seal|Marine mammal that rests on rocky shores
    Walrus|Large marine mammal with tusks
    Raccoon|Masked mammal known for nimble paws
    Flamingo|Pink bird that stands on one leg
    Kangaroo|Australian jumper with a pouch
    Yellowhammer|Songbird with bright yellow plumage
    Zorilla|Striped African mammal also called a polecat
    Aye Aye|Lemur that taps wood to find insects
    Binturong|Tree-dwelling mammal sometimes called a bearcat
    Coelacanth|Ancient lobe-finned fish once thought extinct
    Dugong|Marine herbivore related to the manatee
    Eland|Large antelope native to Africa
    Fossa|Madagascar predator related to mongooses
    Galago|Nocturnal primate also called a bush baby
    Hoatzin|Leaf-eating bird with a distinctive crest
    Indri|Large lemur known for its loud calls
    Jerboa|Desert rodent with long hopping legs
    Kinkajou|Rainforest mammal with a prehensile tail
    Lorikeet|Colorful parrot with a brush-tipped tongue
    Markhor|Wild goat with spiral horns
    Numbat|Australian marsupial that feeds on termites
    Okapi|Forest relative of the giraffe with striped legs
    Pademelon|Small marsupial related to wallabies
    Quetzal|Bird famous for its iridescent green feathers
    Red Panda|Tree-dwelling mammal with a ringed tail
    Saiga|Antelope with an unusual inflated nose
    Tamarin|Small monkey with claw-like nails
    Urial|Wild sheep from Central and South Asia
    Vicuna|Andean camelid prized for fine wool
    Whimbrel|Long-billed migratory shorebird
    Xray Tetra|Transparent freshwater fish
    Yabby|Australian freshwater crayfish
    Zebu|Humped domestic cattle adapted to hot climates
    Agouti|Rodent known for burying seeds in forests
    Bonobo|Great ape closely related to chimpanzees
    Capybara|Large semiaquatic rodent from South America
    Dhole|Wild dog that hunts in packs
    Emu|Large flightless bird from Australia
    Fennec|Small fox with oversized ears
    Genet|Slender spotted mammal from Africa and Europe
    Hartebeest|African antelope with an elongated face
    Ibis|Wading bird with a long curved bill
    Javelina|Pig-like mammal of the Americas
    Kea|Highly intelligent alpine parrot
    Leafcutter Ant|Ant that farms fungus underground
    Marmoset|Tiny monkey with clawed fingers
    Nightjar|Nocturnal bird with a wide mouth
    Orca|Ocean predator also called a killer whale
    Peccary|Hog-like mammal with scent glands
    Quagga|Extinct zebra relative with partial striping
    Rorqual|Large whale with throat pleats
    Shoebill|Tall African bird with a massive bill
    Tenrec|Insect-eating mammal from Madagascar
    Uromastyx|Spiny-tailed lizard from arid regions
    Vervet|African monkey known for alarm calls
    Weta|Large flightless insect from New Zealand
    Xeme|Small gull of Arctic coasts
    Yellowthroat|Warbler with a black facial mask
    Zokor|Burrowing rodent from Asia
    Albatross|Ocean bird with an enormous wingspan
    Babirusa|Wild pig with upward-curving tusks
    Civet|Mammal once associated with perfume production
    Dik Dik|Tiny antelope with a pointed snout
    Eider|Sea duck valued for soft down feathers
    Fisher|Forest mustelid related to martens
    Guineafowl|Speckled ground bird native to Africa
    Honeyguide|Bird known for leading humans to beehives
    Impala|Graceful antelope famous for leaping
    Jacana|Wading bird with extremely long toes
    Kudu|Antelope with elegant spiral horns
    Lapwing|Plover with a crest and erratic flight
    Moorhen|Wetland bird with large feet
    Nighthawk|Bird active at dusk with acrobatic flight
    Osprey|Fish-eating raptor with reversible outer toes
    Pika|Small mountain mammal related to rabbits
    Quahog|Edible hard-shelled clam
    Rhea|Large South American flightless bird
    Sifaka|Lemur that moves with sideways hops
    Tragopan|Colorful pheasant with inflatable wattles
    Viscacha|Rodent resembling a rabbit-chinchilla hybrid
    """, difficulty: 3)

    private static let geographyHard = wordList("""
    Canada|Large country north of the United States
    Brazil|Largest country in South America
    Japan|Island country in East Asia
    Egypt|Country known for pyramids and the Nile
    Mexico|Country south of the United States
    France|European country known for Paris
    India|Large South Asian country
    Alaska|Largest U.S. state by area
    Sahara|Famous desert in North Africa
    Everest|Highest mountain above sea level
    Amazon|Major river and rainforest in South America
    Sydney|Australian city known for its opera house
    Tokyo|Capital city of Japan
    London|Capital city of the United Kingdom
    Berlin|Capital city of Germany
    Rome|Capital city of Italy
    Madrid|Capital city of Spain
    Nile|Famous river in northeastern Africa
    Arctic|Cold region around the North Pole
    Alps|Mountain range in Europe
    Andes|Long mountain range in South America
    Bali|Indonesian island known for beaches and temples
    Hawaii|Pacific island state of the United States
    Dubai|City known for skyscrapers in the United Arab Emirates
    Greece|European country with many islands
    Zagros Mountains|Mountain chain stretching across Iran
    Aegean Sea|Body of water between Greece and Turkey
    Balkan Peninsula|Peninsula in southeastern Europe
    Caspian Sea|World's largest inland body of water
    Drake Passage|Rough ocean corridor south of Cape Horn
    Erie Canal|Historic waterway linking the Hudson River to the Great Lakes
    Fiordland|Southwestern New Zealand region of dramatic fjords
    Galapagos|Pacific archipelago linked to evolution studies
    Hindu Kush|Mountain range extending through Afghanistan and Pakistan
    Naypyidaw|Capital of Myanmar
    Jutland Peninsula|Peninsula forming mainland Denmark
    Karakoram|Asian range containing some of the highest peaks
    Labrador Sea|North Atlantic sea between Greenland and Canada
    Mariana Trench|Deep ocean trench in the western Pacific
    Niger Delta|Oil-rich delta in West Africa
    Okavango Delta|Inland delta in Botswana
    Pamir Mountains|High mountain knot in Central Asia
    Queen Charlotte Sound|New Zealand sound near the Marlborough region
    Rann of Kutch|Seasonal salt marsh in western India
    Serengeti|East African plain famous for annual migrations
    Tian Shan|Mountain system across Central Asia
    Chisinau|Capital of Moldova
    Vindhya Range|Central Indian hill system
    Antananarivo|Capital of Madagascar
    Yucatan Peninsula|Region separating the Gulf of Mexico and Caribbean
    Zambezi River|River that flows over Victoria Falls
    Andaman Sea|Sea east of the Bay of Bengal
    Bering Strait|Narrow waterway between Alaska and Russia
    Celebes Sea|Deep sea between the Philippines and Indonesia
    Dardanelles|Strategic strait in northwestern Turkey
    Euphrates|Historic river of Mesopotamia
    Flores Island|Indonesian island east of Sumbawa
    Gulf of Aden|Waterway connecting the Red Sea and Arabian Sea
    Hudson Bay|Vast inland sea in northeastern Canada
    Isthmus of Panama|Narrow land bridge linking North and South America
    Kermadec Islands|Remote volcanic arc northeast of New Zealand
    Laptev Sea|Arctic sea north of Siberia
    Massif Central|Highland region in south-central France
    Nullarbor Plain|Treeless limestone plain in southern Australia
    Omo Valley|Region in Ethiopia known for paleoanthropology
    Pyrenees|Mountain range between Spain and France
    Qattara Depression|Low-lying desert basin in Egypt
    Red Sea|Narrow sea between northeast Africa and Arabia
    Svalbard|Arctic archipelago under Norwegian rule
    Tasman Sea|Sea between Australia and New Zealand
    Dushanbe|Capital of Tajikistan
    Bishkek|Capital of Kyrgyzstan
    Wrangell Mountains|Volcanic range in Alaska
    Ljubljana|Capital of Slovenia
    Zanzibar Archipelago|Island group off the coast of Tanzania
    Aral Sea|Shrinking lake between Kazakhstan and Uzbekistan
    Bosphorus|Strait dividing European and Asian Turkey
    Carpathian Mountains|Arc-shaped range in Central and Eastern Europe
    Dead Sea|Salt lake bordered by Jordan and Israel
    English Channel|Waterway separating England and France
    Fertile Crescent|Historic region linked to early agriculture
    Great Rift Valley|Long geological trench in East Africa
    Horn of Africa|Eastern projection of the African continent
    Izu Peninsula|Peninsula southwest of Tokyo
    Jordan Rift|Section of the larger Great Rift system
    Kuril Islands|Volcanic island chain between Japan and Russia
    Loess Plateau|Chinese plateau known for windblown silt
    Mozambique Channel|Channel between Madagascar and mainland Africa
    Negev Desert|Arid region in southern Israel
    Olympic Peninsula|Peninsula in northwestern Washington State
    Po Valley|Fertile plain in northern Italy
    Qilian Mountains|Mountain chain along the edge of the Tibetan Plateau
    Ross Sea|Antarctic sea near the Ross Ice Shelf
    Sinai Peninsula|Triangular peninsula connecting Africa and Asia
    Thimphu|Capital of Bhutan
    Uvs Lake|Large saline lake in western Mongolia
    Valdai Hills|Upland area in western Russia
    Wakhan Corridor|Narrow strip of territory in northeastern Afghanistan
    Yellow Sea|Sea between China and the Korean Peninsula
    Zanskar Range|High mountain range in northern India
    """, difficulty: 3)

    private static let foodsHard = wordList("""
    Pizza|Baked dough topped with sauce and cheese
    Burger|Sandwich built around a patty in a bun
    Pasta|Italian noodles served with many sauces
    Taco|Folded tortilla filled with meat or vegetables
    Sushi|Japanese dish built with seasoned rice
    Burrito|Filled tortilla wrapped into a roll
    Pancake|Flat cake cooked on a griddle
    Waffle|Grid-pattern breakfast cake
    Cookie|Small baked sweet treat
    Muffin|Individual baked quick bread
    Lasagna|Layered baked pasta dish
    Omelette|Egg dish folded around a filling
    Noodles|Long strips of cooked dough
    Pretzel|Twisted baked bread with a chewy crust
    Popcorn|Puffed corn often eaten at the movies
    Brownie|Dense chocolate dessert bar
    Donut|Fried ring-shaped pastry
    Sandwich|Filling placed between slices of bread
    Cupcake|Small frosted cake baked in a wrapper
    Hotdog|Sausage served inside a bun
    Meatball|Seasoned ball of ground meat
    Dumpling|Small piece of dough often filled or boiled
    Smoothie|Blended cold drink made with fruit
    Cereal|Breakfast grains served in a bowl
    Sausage|Seasoned ground meat packed in a casing
    Zabaglione|Italian custard-like dessert whipped with wine
    Arancini|Fried stuffed rice balls from Sicily
    Bibimbap|Korean rice bowl topped with mixed ingredients
    Cacciucco|Tuscan fish stew with tomato broth
    Dolmades|Stuffed grape leaves common in the eastern Mediterranean
    Enchilada Suiza|Enchilada topped with a creamy green sauce
    Focaccia|Italian flat oven-baked bread
    Galantine|Deboned poultry dish served cold
    Harissa|North African chili paste
    Idli|Steamed rice cakes from South India
    Jjajangmyeon|Korean noodles in black bean sauce
    Katsuobushi|Dried skipjack tuna flakes used in Japanese cooking
    Lahmacun|Thin flatbread topped with minced meat
    Menemen|Turkish scrambled eggs with tomato and peppers
    Nicoise Salad|Salad associated with Nice and Mediterranean ingredients
    Ossobuco|Braised veal shank dish from Milan
    Pappardelle|Wide ribbon pasta
    Qatayef|Stuffed pancake dessert popular during Ramadan
    Rillettes|French spread made from slow-cooked meat
    Souvlaki|Greek skewered meat dish
    Tagliatelle|Ribbon pasta traditionally served with rich sauces
    Upma|Savory South Indian semolina breakfast dish
    Vichyssoise|Chilled leek and potato soup
    Waldorf Salad|Apple salad with celery and walnuts
    Xacuti|Goan curry made with toasted spices and coconut
    Yassa|West African dish marinated with onion and citrus
    Zaru Soba|Cold buckwheat noodles served with dipping sauce
    Arepas|Corn cakes common in northern South America
    Biryani|Layered rice dish scented with spices
    Cevapcici|Grilled minced meat sausages from the Balkans
    Dashi|Japanese stock often made with kombu and bonito
    Empanada Gallega|Large savory pie from Galicia
    Farfalle|Bow-tie shaped pasta
    Gravlax|Cured salmon seasoned with dill
    Huevos Rancheros|Egg dish with tortillas and salsa
    Iskender Kebab|Turkish kebab served over bread with yogurt
    Jicama Slaw|Crunchy slaw based on a mild root vegetable
    Kibbeh|Dish made from bulgur and spiced meat
    Labneh|Strained yogurt used as a spread or dip
    Muhammara|Pepper and walnut spread from the Levant
    Nasi Goreng|Indonesian fried rice with sweet soy notes
    Oyakodon|Japanese bowl of chicken, egg, and rice
    Pastilla|Moroccan pie blending savory and sweet flavors
    Quenelle|Light dumpling traditionally made from fish or meat
    Romesco|Catalan sauce with peppers and nuts
    Sabich|Israeli pita sandwich with eggplant and egg
    Tonkotsu|Pork-bone broth style of ramen
    Uttapam|South Indian pancake topped with vegetables
    Vermicelli Bowl|Rice noodle bowl common in Vietnamese cuisine
    Waterzooi|Belgian stew of chicken or fish in creamy broth
    Xinxim|Brazilian stew with shrimp, coconut, and palm oil
    Yakitori|Japanese grilled chicken skewers
    Ziti al Forno|Oven-baked pasta with sauce and cheese
    Avgolemono|Greek soup thickened with egg and lemon
    Baklava|Layered pastry filled with nuts and syrup
    Cassoulet|Slow-cooked bean casserole from southern France
    Dan Dan Noodles|Spicy Sichuan noodles with sesame and chili
    Etouffee|Cajun or Creole smothered shellfish dish
    Frittata|Italian open-faced egg dish
    Goulash|Paprika-rich stew from Central Europe
    Hotteok|Sweet Korean filled pancake
    Ikan Bakar|Southeast Asian grilled fish dish
    Jollof Rice|West African tomato-based rice dish
    Knafeh|Levantine dessert with cheese and crisp pastry
    Loco Moco|Hawaiian dish with rice, burger patty, and gravy
    Mapo Tofu|Sichuan tofu dish with numbing chili heat
    Nasi Lemak|Coconut rice dish considered iconic in Malaysia
    Orecchiette|Ear-shaped pasta from southern Italy
    Pozole|Mexican hominy soup often made with pork
    Qorma|Slow-cooked curry thickened with yogurt or nuts
    Rosti|Swiss potato pancake with a crisp crust
    Spanakopita|Greek spinach and feta pastry
    Tabbouleh|Herb-heavy salad with bulgur and lemon
    Uramaki|Inside-out style of sushi roll
    Varenyky|Filled dumplings common in Ukrainian cuisine
    """, difficulty: 3)

    private static let objectsHard = wordList("""
    Laptop|Portable personal computer
    Backpack|Bag carried on the back
    Pencil|Writing tool with graphite inside
    Helmet|Protective gear worn on the head
    Blanket|Soft cover used for warmth
    Wallet|Small case for money and cards
    Mirror|Reflective surface used to see yourself
    Camera|Device used to take photos
    Scissors|Tool used for cutting paper or fabric
    Toaster|Kitchen appliance that browns bread
    Pillow|Soft support for resting the head
    Kettle|Container used to boil water
    Remote|Handheld device used to control electronics
    Bicycle|Two-wheeled vehicle powered by pedaling
    Suitcase|Luggage used for travel
    Notebook|Book of blank or lined pages for writing
    Headphones|Device worn over ears to listen to audio
    Flashlight|Portable electric light
    Umbrella|Foldable cover used in the rain
    Keyboard|Set of keys used for typing
    Charger|Device used to refill a battery
    Microwave|Appliance used to heat food quickly
    Sofa|Long cushioned seat
    Towel|Cloth used for drying
    Clock|Device that shows the time
    Flange|Rim or collar used for strength or attachment
    Galvanometer|Instrument that detects small electric currents
    Haversack|Bag traditionally carried over one shoulder
    Ice Auger|Tool used to drill holes through ice
    Jacquard Loom|Loom that uses punched patterns to weave designs
    Kaleidoscope|Tube that creates repeating mirrored patterns
    Lathe|Machine that rotates material for shaping
    Monocle|Single corrective lens worn in one eye
    Nozzle|Attachment that controls the direction of fluid flow
    Odometer|Device that records traveled distance
    Quern|Ancient hand mill for grinding grain
    Ratchet|Mechanism allowing motion in only one direction
    Scabbard|Protective sheath for a blade
    Thimble|Protective cap worn while sewing
    Valise|Travel bag with a rigid shape
    Winch|Mechanical device for winding cable or rope
    Abacus|Manual counting frame with sliding beads
    Bellows|Air-pumping device used to intensify a fire
    Carabiner|Spring-loaded metal clip used in climbing
    Drawknife|Blade with handles on both ends for shaping wood
    Easel|Stand used to support an artist's canvas
    Feeler Gauge|Thin strip used to measure small gaps
    Gnomon|Part of a sundial that casts the shadow
    Grommet|Reinforcing ring inserted into material
    Handplane|Woodworking tool for smoothing timber
    Insulator|Object that resists electrical or thermal transfer
    Jigsaw|Power tool with a reciprocating blade
    Keytar|Portable keyboard worn with a strap
    Linstock|Tool once used to ignite cannons
    Mortar and Pestle|Tool for crushing and grinding ingredients
    Nyckelharpa|Swedish keyed string instrument
    Oarlock|Fitting that holds an oar in place
    Pulley|Wheel mechanism used to lift loads
    Quill Pen|Writing instrument made from a feather shaft
    Rasp|Coarse file used for shaping material
    Soldering Iron|Tool used to melt solder onto joints
    Turntable|Rotating platform used for records or display
    Upholstery Awl|Pointed tool used in heavy sewing work
    Vise|Clamping tool fixed to a bench
    Whetstone|Stone used to sharpen blades
    Xacto Knife|Precision cutting knife used for detail work
    Yarn Swift|Device that holds yarn while it is wound
    Zipline Harness|Safety gear worn for cable descent
    Aperture|Adjustable opening that controls light
    Bulkhead|Partition wall inside a ship or aircraft
    Clamp|Device that holds items tightly together
    Diapason|Another term for a tuning fork
    Eyepiece|Lens assembly viewed through in an instrument
    Flywheel|Heavy rotating wheel that stores momentum
    Grapnel|Hooked tool used for grabbing or anchoring
    Hinge|Jointed hardware allowing a panel to swing
    Inkwell|Container for storing writing ink
    Javelin|Spear-like implement used in athletics
    Kerosene Lamp|Lamp that burns fuel in a wick
    Latch|Fastener that keeps a door or gate closed
    Mainsail|Principal sail on a sailing vessel
    Needlepoint Frame|Frame used to hold fabric taut for stitching
    Orrery|Mechanical model of the solar system
    Pipette|Tool for transferring small volumes of liquid
    Quadcopter|Aircraft lifted by four rotors
    Rivet Gun|Tool that fastens rivets into place
    Sprocket|Toothed wheel that engages a chain
    Trivet|Stand used to protect surfaces from hot cookware
    Utility Knife|Retractable knife for general cutting tasks
    Voltage Meter|Instrument that measures electrical potential
    Whisk|Kitchen tool for blending and aerating
    Xylorimba|Percussion instrument combining marimba and xylophone ranges
    Yardarm|Horizontal spar attached to a ship's mast
    Zirconia Blade|Ceramic blade known for hard sharp edges
    Anchor Windlass|Mechanism used to raise and lower an anchor
    Breadboard|Board used for prototyping electronic circuits
    Cantilever|Projecting support fixed at one end
    Divot Tool|Small tool used to repair turf on a green
    Endoscope|Instrument used to view inside the body
    Fresnel Lens|Stepped lens designed to focus light efficiently
    """, difficulty: 3)

    private static func word(_ answer: String, _ hint: String, _ difficulty: Int) -> HangmanWord {
        HangmanWord(answer: answer, hint: hint, difficulty: difficulty)
    }

    private static func wordList(_ raw: String, difficulty: Int) -> [HangmanWord] {
        raw
            .split(separator: "\n")
            .map { line in
                let parts = line.split(separator: "|", maxSplits: 1).map(String.init)
                return word(parts[0], parts[1], difficulty)
            }
    }

    private static func exactLevelWords(
        easy: [HangmanWord],
        medium: [HangmanWord],
        hard: [HangmanWord]
    ) -> [GameLevel: [HangmanWord]] {
        [
            .easy: normalized(easy, targetCount: 100, difficulty: 1, fallback: medium),
            .medium: normalized(medium, targetCount: 100, difficulty: 2, fallback: hard),
            .hard: normalized(hard, targetCount: 100, difficulty: 3, fallback: [])
        ]
    }

    private static func normalized(
        _ primary: [HangmanWord],
        targetCount: Int,
        difficulty: Int,
        fallback: [HangmanWord]
    ) -> [HangmanWord] {
        var ordered = uniqueWords(from: primary)

        if ordered.count < targetCount {
            let fallbackWords = uniqueWords(from: fallback).filter { candidate in
                !ordered.contains { $0.answer.caseInsensitiveCompare(candidate.answer) == .orderedSame }
            }
            ordered.append(contentsOf: fallbackWords)
        }

        return Array(ordered.prefix(targetCount)).map { word in
            HangmanWord(answer: word.answer, hint: word.hint, difficulty: difficulty)
        }
    }

    private static func uniqueWords(from words: [HangmanWord]) -> [HangmanWord] {
        var seen = Set<String>()

        return words.filter { word in
            let key = word.answer.lowercased()
            return seen.insert(key).inserted
        }
    }

    private static func complexityScore(for word: HangmanWord) -> Int {
        let trimmedAnswer = word.answer.replacingOccurrences(of: Strings.Game.blankCharacter, with: "")
        let uniqueLetters = Set(trimmedAnswer.uppercased()).count
        let wordCount = word.answer.split(separator: Character(Strings.Game.blankCharacter)).count
        let rareLetterCount = trimmedAnswer.uppercased().filter { "QXZJVKYW".contains($0) }.count

        return (trimmedAnswer.count * 4)
            + (uniqueLetters * 3)
            + (max(wordCount - 1, 0) * 6)
            + (rareLetterCount * 4)
            + (word.difficulty * 10)
    }
}
