// Файл: lib/data/predefined_templates.dart

// Импортируем нужные модели и enums
import '../models/checklist_template.dart';
import '../models/checklist_item.dart';
import '../models/enums.dart';

// Определяем финальную переменную для каждого шаблона

final arrivalPscEngineChecklist = ChecklistTemplate(
  name: 'Arrival Engine Room Checklist for PSC', // Название
  version: 1,
  items: [
    // --- Mechanical Systems ---
    ChecklistItem(
      order: 1,
      section: 'Mechanical Systems',
      text: 'Are all auxiliary engines in good working order?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 2,
      section: 'Mechanical Systems',
      text:
          'Do all components of the main propulsion engine function correctly and properly?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 3,
      section: 'Mechanical Systems',
      text:
          'Has it been confirmed that all piping is free from leaks and temporary repairs (soft patches)?',
      details: '(See additional info p.24)',
      responseType: ResponseType.okNotOkNA,
    ),

    // --- Cleanliness and Safety ---
    ChecklistItem(
      order: 4,
      section: 'Cleanliness and Safety',
      text:
          'Are all tank tops and bilges clean and free of excessive oil or debris? Are tools and equipment stored properly to prevent hazards? Are emergency exits unobstructed? Has it been confirmed that there are no oil leaks, deposits, or slicks present in any area?',
      details: '(See additional info p.22)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 5,
      section: 'Cleanliness and Safety',
      text:
          'Are all emergency exits clearly marked and easily accessible without any obstructions?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 6,
      section: 'Cleanliness and Safety',
      text:
          'Do the self-closing mechanisms of all fire doors function correctly and are they free from any hold-back devices, where self-closing doors are required by SOLAS regulations?',
      details: '(See additional info p.14)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 7,
      section: 'Cleanliness and Safety',
      text:
          'Is the insulation on all "A" class bulkheads and decks in good condition, without damage or deterioration? Are all cable penetrations in "A" or "B" class divisions properly sealed and in good condition to maintain fire integrity?',
      details: '(See additional info p.15)',
      responseType: ResponseType.okNotOkNA,
    ),

    // --- Emergency Equipment ---
    ChecklistItem(
      order: 8,
      section: 'Emergency Equipment',
      text:
          'Are all EEBDs stowed in readily accessible locations and in good order? Is the indicated air pressure within the acceptable range for each EEBD?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 9,
      section: 'Emergency Equipment',
      text:
          'Are all emergency lights in the engine room, engine control room (ECR), and escape trunk in good working order? Are all light guards intact and not damaged?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 10,
      section: 'Emergency Equipment',
      text:
          'Do the emergency shut-off valves for fuel oil (FO) tanks operate correctly and can they be easily accessed in an emergency?',
      details: '(See additional info p.23)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 11,
      section: 'Emergency Equipment',
      text:
          'Have all portable fire extinguishers been serviced within the required intervals and are they clearly marked with the date of the last service? Are the pressure gauges indicating the correct pressure?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 12,
      section: 'Emergency Equipment',
      text:
          'Are all fireman\'s outfits complete, in good condition, and readily accessible? Are the torches within the outfits in good working order and equipped with charged batteries? Have all cylinders for self-contained breathing apparatus (SCBA) been properly serviced and within their hydrostatic test date? Are there adequate onboard means for recharging SCBA cylinders, or is a sufficient number of fully charged spare cylinders readily available for use during drills and emergencies?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 13,
      section: 'Emergency Equipment',
      text:
          'Are all fire pumps capable of being started and operating at their rated capacity, providing adequate pressure at the fire hydrants?',
      details: '(See additional info p.23)',
      responseType: ResponseType.okNotOkNA,
    ),

    // --- Fuel and Oil Systems ---
    ChecklistItem(
      order: 14,
      section: 'Fuel and Oil Systems',
      text:
          'Where required, are high-pressure fuel lines fitted with a jacketed system and are spray shields correctly installed? Are the associated leakage detection alarms functioning correctly?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 15,
      section: 'Fuel and Oil Systems',
      text:
          'Does the oily water separating equipment operate effectively and in accordance with regulations? Are the casings and discharge lines free from excessive corrosion or wastage? Is the interior of the discharge lines clean and free from oil residue or accumulated dirt? Has it been verified that no unauthorized bypass lines have been fitted to the system?',
      details: '(See additional info p.24)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 16,
      section: 'Fuel and Oil Systems',
      text:
          'Are all maintenance activities related to piping systems and the oily water separating equipment accurately and fully recorded in the Oil Record Book, including dates and details of work performed?',
      responseType: ResponseType.okNotOkNA,
    ),

    // --- Pollution Prevention ---
    ChecklistItem(
      order: 17,
      section: 'Pollution Prevention',
      text:
          'Is the sewage treatment plant in good working order and being operated in accordance with regulations? If untreated sewage stored in holding tanks is discharged, is an approved discharge rate table readily available onboard?',
      details:
          '(Refer to relevant guidelines, e.g., ClassNK Technical Information, No.TEC-0758.)',
      responseType: ResponseType.okNotOkNA,
    ),

    ChecklistItem(
      order: 18,
      section: 'Pollution Prevention',
      text:
          'Does the 15 ppm alarm system for the oily water separator function correctly, including automatic stopping devices, audible and visual alarms, and associated gauges? Is a valid and up-to-date calibration certificate for the 15 ppm alarm system readily available onboard?',
      details:
          '(This applies to equipment certified under MEPC.107(49) or later standards.)',
      responseType: ResponseType.okNotOkNA,
    ),
  ],
);

// --- НОВЫЙ ШАБЛОН: Technical Internal Inspection Rev. 08 ---
final technicalInspectionRev08 = ChecklistTemplate(
  name: 'Technical Internal Inspection Rev. 08',
  version: 8,
  items: [
    // Documentation--------------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 1, // Наша сквозная нумерация
      section: 'Documentation',
      text:
          '1.1 Are all statutory Certificates are valid and respectively endorsed? (to be checked in office prior inspection)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 2,
      section: 'Documentation',
      text:
          '1.2 Are no obsolete Certificates in folders and Maitenance System? (to be checked in office prior inspection)',
      responseType: ResponseType.okNotOkNA,
    ),
    // Подраздел "Flag State Requirements" относится к секции "Documentation"
    ChecklistItem(
      order: 3,
      section: 'Documentation',
      text:
          '1.3 Are they Implemented and updated? Are Bulletins filed (Paper or Electronical)',
      responseType: ResponseType.okNotOkNA,
    ),
    // Подраздел "Various Manuals and Plans" относится к секции "Documentation"
    ChecklistItem(
      order: 4,
      section: 'Documentation',
      text: '1.4 SMS Handbook - Known by all Crewmembers',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 5,
      section: 'Documentation',
      text:
          '1.5 SOPEP Plan - Updated with Contact Points? (to be checked in office prior inspection)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 6,
      section: 'Documentation',
      text: '1.6 Cargo Security Plan available and approved',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 7,
      section: 'Documentation',
      text: '1.7 SOPEP Plan available and approved', // Повторяется? В CSV так.
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 8,
      section: 'Documentation',
      text: '1.8 Garbage Management Plan available',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 9,
      section: 'Documentation',
      text: '1.9 Emergency Towage Plan available and approved',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 10,
      section: 'Documentation',
      text: '1.10 Ballast Water Management Plan available and approved',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 11,
      section: 'Documentation',
      text: '1.11 Ship Energy Efficient Management Pland (SEEMP)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 12,
      section: 'Documentation',
      text: '1.12 Manual for Entering Enclosed Spaces',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 13,
      section: 'Documentation',
      text: '1.13 IHM Maintenance Manual',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 14,
      section: 'Documentation',
      text: '1.14 Asbestos Procedure Manual',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 15,
      section: 'Documentation',
      text: '1.15 Cyber Security Plan',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 16,
      section: 'Documentation',
      text: '1.16 Damage Control Booklet',
      responseType: ResponseType.okNotOkNA,
    ),

    ChecklistItem(
      order: 17,
      section: 'Documentation',
      text: '1.17 Energy Storage System Manual',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 18,
      section: 'Documentation',
      text: '1.18 Shipboard Operation Manual',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 19,
      section: 'Documentation',
      text: '1.19 Safe Mooring operation manual',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 20,
      section: 'Documentation',
      text:
          '1.20 Check by random that publications are available and updated', // И еще один
      responseType: ResponseType.okNotOkNA,
    ),

    // Navigation Equipment---------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 21,
      section: 'Navigation Equipment',
      text: '2.1 Are nautical publications including pilot books, list of lights, sailing directions, tide tables, code of signals to be used for the intended voyage updated to the latest available amendments/corrections?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 22,
      section: 'Navigation Equipment',
      text:
          '2.2 Are Charts to be used for the intended voyage and in General updated to the latest available Notice to Mariners? (Ref CC 12.12)',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 23,
      section: 'Navigation Equipment',
      text:
          '2.3 Is a system for correcting all nautical publications onboard available?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 24,
      section: 'Navigation Equipment',
      text:
          '2.4 Are navigational instruments as radar including ARPA devices, echo sounder and speed log in operational condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 25,
      section: 'Navigation Equipment',
      text:
          '2.5 Are the navigation lights incl. duplication and failure alarm working?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 26,
      section: 'Navigation Equipment',
      text:
          '2.6 Is the steering gear including rudder angle indicator as well as emergency steering gear including switch-over devices in operating condition and the steering gear alarm functioning? Ref CC 12.5',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 27,
      section: 'Navigation Equipment',
      text: '2.7 Are instructions for handling posted in vicinity?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 28,
      section: 'Navigation Equipment',
      text: '2.8 Are daylight shapes in operational condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 29,
      section: 'Navigation Equipment',
      text:
          '2.9 Is the daylight signalling lamp and the independent power supply in good operational condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 30,
      section: 'Navigation Equipment',
      text:
          '2.10 Is the automatic position indicator (e.g. GPS) available and in good condition?  ',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 31,
      section: 'Navigation Equipment',
      text:
          '2.11 Are communication systems between bridge and engine room and steering gear room in working condition? Ref CC 12.4',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 32,
      section: 'Navigation Equipment',
      text:
          '2.12 Is the NAVTEX receiver in good working condition and enough spare paper available?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 33,
      section: 'Navigation Equipment',
      text: '2.13 Is the echosounder in good working condition',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 34,
      section: 'Navigation Equipment',
      text:
          '2.14 Is illustrated table of life saving signals incl. helicopter communication signs posted on the bridge?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 35,
      section: 'Navigation Equipment',
      text:
          '2.15 Is the magnetic steering compass in good condition and properly visible from steering position?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 36,
      section: 'Navigation Equipment',
      text:
          '2.16 Is a spare magnetic compass available and in good condition? Ref CC 12.24',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 37,
      section: 'Navigation Equipment',
      text: '2.17 Is an updated calibration table available?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 38,
      section: 'Navigation Equipment',
      text:
          '2.18 Is the AIS system installed, constantly switched on and is the existence verified in the Safety Equipment’s Record “E”?',
      responseType: ResponseType.okNotOkNA,
    ),

    // Radio Equipment--------------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 39,
      section: 'Radio Equipment',
      text:
          '3.1 Are all components of the GMDSS transmitting and receiving equipment, including sources of energy, properly working?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 40,
      section: 'Radio Equipment',
      text:
          '3.2 Are radio operators familiar with cancellation procedures for false distress alarms?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 41,
      section: 'Radio Equipment',
      text:
          '3.3 Has the radio log book been kept as required, incl. records of tests?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 42,
      section: 'Radio Equipment',
      text:
          '3.4 Are portable VHF handheld radios for survival craft, including batteries with spares / re-charger, in good working condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 43,
      section: 'Radio Equipment',
      text:
          '3.5 Are antenna systems in good condition without any signs of corrosion or damage?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 44,
      section: 'Radio Equipment',
      text:
          '3.6 Are Radar Transponders in working condition and ready in case of emergency?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 45,
      section: 'Radio Equipment',
      text:
          "3.7 Are they serviced following the manufacturer's requirements by shore service?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 46,
      section: 'Radio Equipment',
      text:
          '3.8 Is the EPIRB in the correct and float-free position? Is the life date of the battery and hydrostatic release still valid?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 47,
      section: 'Radio Equipment',
      text: '3.9 Are radio publications and manuals updated?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 48,
      section: 'Radio Equipment',
      text:
          '3.10 Is a valid COC (Certificate of Complaince) for VDR is available on board? VDR/EPIRB battery, acoustic beacon and HRU are valid?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 49,
      section: 'Radio Equipment',
      text: '3.11 Is a valid Radio Licence onboard?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 50,
      section: 'Radio Equipment',
      text:
          '3.12 Are all Radio Equipment in the Radio License corresponding with the equipment on board?',
      responseType: ResponseType.okNotOkNA,
    ),

    // Safety in General--------------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 51,
      section: 'Safety in General',
      text:
          '4.1 Have up-to-date fire control plans been posted in accommodation alleyways, are they readable, and show a sign of approval?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 52,
      section: 'Safety in General',
      text:
          '4.2 Is one copy stored in a prominently marked, weather-tight container outside the deckhouse?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 53,
      section: 'Safety in General',
      text:
          '4.3 Are SOLAS training manuals available? They should provide specific instructions for the appliances installed onboard and be written in a language understood by all crew members.',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 54,
      section: 'Safety in General',
      text:
          '4.4 Are Instruction Manuals for onboard maintenance of life-saving appliances available and understood by all crew members?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 55,
      section: 'Safety in General',
      text: '4.5 Is regular maintenance being recorded?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 56,
      section: 'Safety in General',
      text:
          '4.6 Are Operating Instructions for lifesaving appliances posted on scene and under emergency illumination?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 57,
      section: 'Safety in General',
      text: '4.7 Are they in a language understood by all crew members?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 58,
      section: 'Safety in General',
      text:
          '4.8 ave regular drills for fire fighting, abandon ship, and rescue boat operation been carried out satisfactorily as required?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 59,
      section: 'Safety in General',
      text: '4.9 Are they recorded in the logbook?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 60,
      section: 'Safety in General',
      text:
          '4.10 Is a working language established and recorded in the logbook?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 61,
      section: 'Safety in General',
      text: '4.11  Is a plan or program for maintenance available?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 62,
      section: 'Safety in General',
      text:
          '4.12 Have drills for use of emergency steering gear and switch-over procedures been carried out?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 63,
      section: 'Safety in General',
      text: '4.13 Are they recorded in the logbook?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 64,
      section: 'Safety in General',
      text:
          '4.14 Are up-to-date muster lists written in a language understood by the crew members?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 65,
      section: 'Safety in General',
      text:
          '4.15 Are duties about maintenance of safety equipment included?  Are duties about carrying emergency radio equipment into the survival crafts included? Are names of substitutes of key persons listed?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 66,
      section: 'Safety in General',
      text:
          '4.16 Are they posted on the bridge, in engine control room and accommodation spaces?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 67,
      section: 'Safety in General',
      text:
          "4.17 Are public alarm systems, the general alarm, and the engineer's alarm of the unmanned machinery system working properly?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 68,
      section: 'Safety in General',
      text:
          '4.18 Are all paint materials stored inside the designated paint locker only?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 69,
      section: 'Safety in General',
      text:
          '4.19 Are all escape ways accessible and free of obstructions, and are they properly illuminated?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 70,
      section: 'Safety in General',
      text:
          '4.20 Are IMO symbols properly used for marking escape ways and locations of emergency equipment?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 71,
      section: 'Safety in General',
      text:
          '4.21 Are pilot ladders and related boarding arrangements clean and in good condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 72,
      section: 'Safety in General',
      text:
          '4.22 Is the crew familiar with the use of all lifesaving and firefighting equipment?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 73,
      section: 'Safety in General',
      text:
          '4.23 Is the crew working on the bridge familiar with the steering gear switch-over procedures and with the use of emerg. steering device?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 74,
      section: 'Safety in General',
      text:
          '4.24 Is the key engine crew familiar with emergency power arrangements?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 75,
      section: 'Safety in General',
      text:
          '4.25 Are the key personnel for firefighting familiar with starting the emergency fire pump?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 76,
      section: 'Safety in General',
      text:
          '4.26 Is the designated rescue boat crew familiar with starting the engines?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 77,
      section: 'Safety in General',
      text:
          '4.27 Are responsible personnel familiar with the use of the OWS(Oil Water Separator) arrangements?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 78,
      section: 'Safety in General',
      text:
          '4.28 Are heaving lines made with rope only and not contain added weighting material?',
      responseType: ResponseType.okNotOkNA,
    ),

    // Lifesaving Appliances---------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 79,
      section: 'Lifesaving Appliances',
      text: '5.1 Is rescue boat inventory complete and in good condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 80,
      section: 'Lifesaving Appliances',
      text:
          '5.2 Are the dates of expiration for pyrotechnics and foodstuff rations recorded and not outdated?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 81,
      section: 'Lifesaving Appliances',
      text: '5.3 Are rescue boats complete and in good condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 82,
      section: 'Lifesaving Appliances',
      text: '5.4 Is the inventory as required stored in the boat?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 83,
      section: 'Lifesaving Appliances',
      text:
          '5.5 Are rescue boat engines in good working condition and starting easily?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 84,
      section: 'Lifesaving Appliances',
      text:
          '5.6 Are life rafts and launching arrangements in good working condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 85,
      section: 'Lifesaving Appliances',
      text:
          "5.7 Is the ship's name updated on the outside data placards if available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 86,
      section: 'Lifesaving Appliances',
      text:
          '5.8  Is the hydrostatic release for the rafts properly connected and still valid?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 87,
      section: 'Lifesaving Appliances',
      text:
          '5.9 Is a ladder or other means for embarkation for the additional life raft at the bow(if appropriate) readily available? ',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 88,
      section: 'Lifesaving Appliances',
      text:
          '5.10 Are launching arrangements for rescue boats including limit switches in good condition and without wastage?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 89,
      section: 'Lifesaving Appliances',
      text:
          '5.11 Are the embarkation ladders incl. their shackles and padeyes on deck in good condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 90,
      section: 'Lifesaving Appliances',
      text:
          '5.12 Are wire falls of all launching/recovery arrangements in good condition and turned/renewed as required?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 91,
      section: 'Lifesaving Appliances',
      text: '5.13 Has reversal/renewal of falls/crane wires been recorded?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 92,
      section: 'Lifesaving Appliances',
      text:
          "5.14 Are life buoys (including reflective tape, correct ship's name/home port and lights and smoke signals with non-outdated batteries) available in sufficient amount and in good condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 93,
      section: 'Lifesaving Appliances',
      text:
          '5.15 Is a "heavy" life buoy (4.5kg) attached to the smoke/light-buoy at bridge wings in a free-fall arrangement?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 94,
      section: 'Lifesaving Appliances',
      text:
          '5.16 Are lifejackets (including whistles plus lights and non-outdated batteries) available in sufficient amount and good condition?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 95,
      section: 'Lifesaving Appliances',
      text:
          '5.17 Are line throwing appliances complete with valid expiration dates of the pyrotechnic units?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 96,
      section: 'Lifesaving Appliances',
      text:
          '5.18 Are parachute distress signals available in sufficient amount and in good condition with valid expiration dates placed on the bridge in an appropriate containment which is marked?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 97,
      section: 'Lifesaving Appliances',
      text:
          '5.19 Are immersion suits (including lights and special attachments) available in required amount and stored in good condition.',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 98,
      section: 'Lifesaving Appliances',
      text:
          '5.20 Are additional suits available at remote working stations as required ?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 99,
      section: 'Lifesaving Appliances',
      text:
          '5.21 Has the annual thorough examination of the launching appliances and on-load release gir been carried out by shore service in time ?',
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 100,
      section: 'Lifesaving Appliances',
      text:
          "5.22 Is the emergency illumination at all survival craft stations sufficiently working with illuminating the ship's side and the instructions posted?",
      responseType: ResponseType.okNotOkNA,
    ),

    // Fire Fighting Arrangements-------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 101,
      section: 'Fire Fighting Arrangements',
      text:
          "6.1 Are fire main piping and all hydrants in good condition without signs of corrosion or wastage and without soft patches?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 102,
      section: 'Fire Fighting Arrangements',
      text: "6.2 Are couplings and valves free of leakages?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 103,
      section: 'Fire Fighting Arrangements',
      text:
          "6.3 Are fire pumps including prime mover in engine room in proper working condition and with sufficient delivery of water pressure?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 104,
      section: 'Fire Fighting Arrangements',
      text:
          "6.4 Is emergency fire pump including prime mover in proper working condition with sufficient suction and water pressure to be delivered? Ref CC 12.7",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 105,
      section: 'Fire Fighting Arrangements',
      text: "6.5 Is the crew in charge aware of starting procedures?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 106,
      section: 'Fire Fighting Arrangements',
      text:
          "6.6 Are all fire stations with required equipment of hoses, nozzles, spanners in good condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 107,
      section: 'Fire Fighting Arrangements',
      text:
          "6.7 Are nozzle spray adjustments workable and hoses without deterioration?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 108,
      section: 'Fire Fighting Arrangements',
      text:
          "6.8 Are portable fire extinguishers available in sufficient amount and in good condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 109,
      section: 'Fire Fighting Arrangements',
      text:
          "6.9 Are due dates for required servicing recorded and not outdated?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 110,
      section: 'Fire Fighting Arrangements',
      text:
          "6.10 Are fireman's outfits available in sufficient and complete amount, good condition and ready for use, including breathing apparatus with air bottles properly filled?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 111,
      section: 'Fire Fighting Arrangements',
      text:
          "6.11 Are fixed fire fighting systems for engine room and cargo spaces in proper working condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 112,
      section: 'Fire Fighting Arrangements',
      text: "6.12 Is the CO2 room properly closable and a spare key available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 113,
      section: 'Fire Fighting Arrangements',
      text:
          "6.13 Is the CO2 extinguishing system, where fitted, in good order and clear operations posted? Is the interior dry with CO2?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 114,
      section: 'Fire Fighting Arrangements',
      text: "6.14 Are the last test records of the systems available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 115,
      section: 'Fire Fighting Arrangements',
      text:
          "6.15 Are the fire detection arrangements properly working at all detection points? Ref CC 12.17",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 116,
      section: 'Fire Fighting Arrangements',
      text:
          "6.16 Is the fire extinguishing arrangement in paint locker as required in place and in good working condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 117,
      section: 'Fire Fighting Arrangements',
      text:
          "6.17 Are all fire dampers and ventilation closing appliances including gaskets, handles, screws and other mechanical mechanisms in proper working condition? Ref CC 12.11",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 118,
      section: 'Fire Fighting Arrangements',
      text:
          "6.18 Are all fire doors closing properly by their autom. closing devices?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 119,
      section: 'Fire Fighting Arrangements',
      text:
          "6.19 Are all quick-closing devices for tank shut-off and emergency stop of pumps and fans in proper working condition? Ref CC 12.10",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 120,
      section: 'Fire Fighting Arrangements',
      text:
          "6.20 Are Emergency Breathing Devices (EEBDs) available in required amount (plus addit. training unit) and distributed as per fire plan within superstructure and engine room?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 121,
      section: 'Fire Fighting Arrangements',
      text:
          "6.21 Is the international shore connection including reducer piece with appropriate bolts and nuts as per safety plan available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 122,
      section: 'Fire Fighting Arrangements',
      text:
          "6.22 Are Water mist alarm system in working condition and tested regularly?",
      responseType: ResponseType.okNotOkNA,
    ),

    // Hull and Machinery Condition -----------------------------------------------------------------------------------------
    ChecklistItem(
      order: 123,
      section: 'Hull and Machinery Condition',
      text:
          "7.1 As far as visible, are the ship's side shell plates without damage and excessive wastage?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 124,
      section: 'Hull and Machinery Condition',
      text:
          "7.2 Is the structure of cargo holds with regard to bulkheads, frames, brackets, tank tops etc. without damages and excessive wastage?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 125,
      section: 'Hull and Machinery Condition',
      text:
          "7.3 Are electric cable arrangements properly installed and insulated, no loose wiring?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 126,
      section: 'Hull and Machinery Condition',
      text: "7.4 Are light covers properly fixed on all lamps?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 127,
      section: 'Hull and Machinery Condition',
      text:
          "7.5 Are the forward and aft masts in good order without any damages and heavy corrosions?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 128,
      section: 'Hull and Machinery Condition',
      text: "7.6 Does the main switchboard have insulation mats around it?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 129,
      section: 'Hull and Machinery Condition',
      text:
          "7.7 Is the engine room with regard to work and fire safety in a generally clean condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 130,
      section: 'Hull and Machinery Condition',
      text:
          "7.8 Are the main propulsion system ( Main Engine, Gear and CPP system ) in proper working condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 131,
      section: 'Hull and Machinery Condition',
      text:
          "7.9 Is the Auxiliary Engine and power system including 100% power redundancy in proper working condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 132,
      section: 'Hull and Machinery Condition',
      text:
          "7.10 Is Emergency Generator arrangement for immediate supply of electrical power in proper working condition? Last check of black out test?  Ref CC 12.6 and 12.15",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 133,
      section: 'Hull and Machinery Condition',
      text:
          "7.11 Is the jacketed piping system on high pressure fuel lines properly installed and alarms working?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 134,
      section: 'Hull and Machinery Condition',
      text:
          "7.12 Are the piping systems on deck and gantry crane free of leakages?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 135,
      section: 'Hull and Machinery Condition',
      text:
          "7.13 Are the Anchoring devices in good condition without damages ?  Ref CC 12.9 ",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 136,
      section: 'Hull and Machinery Condition',
      text:
          "7.14 Are the Mooring ropes in good working condition? Condition of windlass and mooring winches?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 137,
      section: 'Hull and Machinery Condition',
      text:
          "7.15 Are the Dip trays for bunker station forward and lub/bunker station stb side clean and in good condition? Ref CC 12.15",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 138,
      section: 'Hull and Machinery Condition',
      text:
          "7.16 Is the Steering gear in good order? Communication with bridge? Gyro repeater synchronized with main gyro compass?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 139,
      section: 'Hull and Machinery Condition',
      text:
          "7.17 Is the Maintenance System up to date and maintenance in according to Entries?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 139,
      section: 'Hull and Machinery Condition',
      text: "7.17 Is the Battery pack in good order and no alarms?",
      responseType: ResponseType.okNotOkNA,
    ),

    //Requirements regarding Load Line---------------------------------------------------------------------------
    ChecklistItem(
      order: 140,
      section: 'Requirements regarding Load Line',
      text:
          "8.1 Are bulwarks, handrails, cat walks, without signs of damage and excessive wastage?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 141,
      section: 'Requirements regarding Load Line',
      text:
          "8.2 Are hatch cover arrangements including gaskets and all closing appliances weather tight and in good condition without signs of wastage?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 142,
      section: 'Requirements regarding Load Line',
      text:
          "8.3 Are the closing devices of all sounding pipes properly working? ",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 143,
      section: 'Requirements regarding Load Line',
      text:
          "8.4 Are weather tight doors including keyhole closing devices and small access hatches in good condition to be closed weather tight?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 144,
      section: 'Requirements regarding Load Line',
      text:
          "8.5 Are draft marks and Plimsoll marks painted in contrasting colour?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 145,
      section: 'Requirements regarding Load Line',
      text:
          "8.6 Are Plimsoll marks permanently marked and in accordance with the Load Line Certificate?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 146,
      section: 'Requirements regarding Load Line',
      text:
          "8.7 Are stability information available, approved by GL and written in a language understood by the ship's command?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 147,
      section: 'Requirements regarding Load Line',
      text:
          "8.8 Are Loading Computer in working condition and tested as appropriate in accordance with instructions?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 147,
      section: 'Requirements regarding Load Line',
      text:
          "8.8 Are Loading Computer in working condition and tested as appropriate in accordance with instructions?",
      responseType: ResponseType.okNotOkNA,
    ),

    // MARPOL Requirements -------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 148,
      section: 'MARPOL Requirements',
      text:
          "9.1 Is the oily water separation system including all piping and solenoid valve arrangements as required in proper working condition and without any illegal by-pass piping?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 149,
      section: 'MARPOL Requirements',
      text:
          "9.2 Is the testing arrangement in proper working condition? Is the crew in charge familiar with the system and its use?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 150,
      section: 'MARPOL Requirements',
      text:
          "9.3 Is 15 ppm alarm and stopping arrangements (if installed) in proper working condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 151,
      section: 'MARPOL Requirements',
      text:
          "9.4 Are all piping arrangements in proper condition without any signs of damage or corrosion",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 152,
      section: 'MARPOL Requirements',
      text:
          "9.5 Is the Oil Record Book kept up-to-date, are the required entries about disposal of oily residues correct and the book periodically signed by the Master? Are correct codes used for all entries ?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 153,
      section: 'MARPOL Requirements',
      text:
          "9.6 Do the sludge and bilge tanks designated in Form B of the IOPP Certificate and those listed in the engine room oil record book?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 154,
      section: 'MARPOL Requirements',
      text:
          "9.7 Review of receipts (bunker delivery notes). Does ORB records corresponds to BDNs?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 155,
      section: 'MARPOL Requirements',
      text: "9.8 Are detailed bunker transfer instructions available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 156,
      section: 'MARPOL Requirements',
      text:
          "9.9 Is thw Ballast Water Record book kept up-to-date and all entries are correct?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 157,
      section: 'MARPOL Requirements',
      text:
          "9.10 Are Ballast Water Treatment system in good working condition and logs are available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 158,
      section: 'MARPOL Requirements',
      text:
          "9.11 Are engine room bilges and other machinery areas free of excessive oil matters?",
      responseType: ResponseType.okNotOkNA,
    ),

    // Accommodation and Living Conditions --------------------------------------------------------------------------------
    ChecklistItem(
      order: 159,
      section: 'Accommodation and Living Conditions',
      text:
          "10.1 Are the sanitary facilities in crew accommodation clean and in proper condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 160,
      section: 'Accommodation and Living Conditions',
      text: "10.2 All emergency lighting fixture properly marked?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 161,
      section: 'Accommodation and Living Conditions',
      text: "10.3 Are alleways free of obstructions and exits clearly marked?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 162,
      section: 'Accommodation and Living Conditions',
      text:
          "10.4 Are accomodation and ventilation fan emergency stops in good order and clearly marked to indicate the space they serve?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 163,
      section: 'Accommodation and Living Conditions',
      text:
          "10.5 Are laundries free of accumulations of clothingds or clothing that could constitude a fire hazard?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 164,
      section: 'Accommodation and Living Conditions',
      text:
          "10.6 Are all smoke/heat detectors and call points in working order abd tested regulary?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 165,
      section: 'Accommodation and Living Conditions',
      text:
          "10.7 Are all fire doors closing properly by their self-clothing devices and without illegal hold-back?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 166,
      section: 'Accommodation and Living Conditions',
      text:
          "10.8 Are sick bay and medical locker complete and in condition as required?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 167,
      section: 'Accommodation and Living Conditions',
      text:
          "10.9 Are the ventilation and air conditioning arrangement in proper working condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 168,
      section: 'Accommodation and Living Conditions',
      text:
          "10.10 Are the galley and provision rooms clean and without possible signs of vermin? Is the Galley exhaust fan clean? ",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 169,
      section: 'Accommodation and Living Conditions',
      text:
          "10.11 Are regular temperature reading for all refrigerators, freezers recorded?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 170,
      section: 'Accommodation and Living Conditions',
      text:
          "10.12 Is all garbage collected, separated and disposed of in accordance with Garbage Management Regulations?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 171,
      section: 'Accommodation and Living Conditions',
      text:
          "10.13 Is the accommodation ladder incl. hoisting arrangements and safety net in good condition?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 172,
      section: 'Accommodation and Living Conditions',
      text: "10.14 Are store rooms are clean and in proper condition?",
      responseType: ResponseType.okNotOkNA,
    ),

    // Engine Room -------------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 173,
      section: 'Engine Room',
      text:
          "11.1 Is the dead man alarm system, where fitted, in good order and used as required?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 174,
      section: 'Engine Room',
      text: "11.2 Is the Engine Log Book adequately manned?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 175,
      section: 'Engine Room',
      text:
          "11.3 Is Chief Engineer aware of correct procedures for restarting critical equipment?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 176,
      section: 'Engine Room',
      text:
          "11.4 Are the lubrication oil testing programme being utilised and records are available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 177,
      section: 'Engine Room',
      text:
          "11.5 Are procedures posted for blackout recovery? Is Chief Engineer aware of these procedures and practised in performing?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 178,
      section: 'Engine Room',
      text:
          "11.6 Is a comprehensive and up to date inventory of spare parts being maintained?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 179,
      section: 'Engine Room',
      text:
          "11.7 Is Chief Engineer call alarm in good order and tested regularly and the results recorded?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 180,
      section: 'Engine Room',
      text:
          "11.8 Is Chief Engineer familiar with operation of the steering gear in the emergency mode?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 181,
      section: 'Engine Room',
      text:
          "11.9 Has the steering gear alarms and protections been tested and recorded?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 182,
      section: 'Engine Room',
      text: "11.10 Is electric welding equipment in good order?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 183,
      section: 'Engine Room',
      text:
          "11.11 Are the fixed fire extinguishing system, where fitted, in good order and are clear operating instructions posted?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 184,
      section: 'Engine Room',
      text:
          "11.12 Are emergency escape routes clearly marked, unobstructed and adequately lit?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 185,
      section: 'Engine Room',
      text:
          "11.13 Self-closing doors is closing properly and not obstructed. Emergency lighting is provided and in good working condition",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 186,
      section: 'Engine Room',
      text:
          "11.14 Are engine room emergency stops and shut offs clearly marked and do records indicate that they have been regularly tested?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 187,
      section: 'Engine Room',
      text:
          "11.15 Are hot surfaces, particularly diesel engines, free of any evidence of fuel, diesel and lubricating oil?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 188,
      section: 'Engine Room',
      text:
          "11.16 Do engine room machine tools have adequate eye protection available, and are emergency foot stops fitted and functioning?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 189,
      section: 'Engine Room',
      text:
          "11.17 Is all loose gear in the machinery spaces, stores and steering compartment properly secured?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 190,
      section: 'Engine Room',
      text:
          "11.18 Are chemicals properly stowed and are Material Safety Data Sheets available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 191,
      section: 'Engine Room',
      text:
          "11.19 Are machinery spaces and steering compartments clean and free from obvious leaks and is the overall standard of housekeeping and fabric maintenance satisfactory?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 192,
      section: 'Engine Room',
      text:
          "11.20 Is the bilge high level alarm system regularly tested and are records maintained?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 193,
      section: 'Engine Room',
      text:
          "11.21 Are seawater pumps, sea chests and associated pipework in a satisfactory condition and free of hard rust and temporary repairs, particularly outboard of the ship-side valves?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 194,
      section: 'Engine Room',
      text:
          "11.22 Are the following, where applicable, all in good order and do they appear to be well maintained?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 195,
      section: 'Engine Room',
      text:
          "11.23 The main engine including the main gear, shafting and CPP system",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 196,
      section: 'Engine Room',
      text:
          "11.24 Auxiliary engines and generators, including shaft and emergency generators",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 197,
      section: 'Engine Room',
      text: "11.25 Boilers, including waste heat and domestic boilers",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 198,
      section: 'Engine Room',
      text:
          "11.26 Check of engines cooling and boiler water treatments, perform tests onboard",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 199,
      section: 'Engine Room',
      text:
          "11.27 Compressors including main, instrument and emergency air compressors",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 200,
      section: 'Engine Room',
      text: "11.28 Sewage plant including treatment plant, if fitted",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 201,
      section: 'Engine Room',
      text: "11.29 Bilge pumping arrangements and the oily water separator",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 202,
      section: 'Engine Room',
      text:
          "11.30 Pipework, including steam, fuel, lubricating oil, seawater, sewage, drain and air pipes, etc.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 203,
      section: 'Engine Room',
      text:
          "11.31 Ventilation fans and trunking including fire dampers and fire doors",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 204,
      section: 'Engine Room',
      text: "11.32 Fresh water tanks and associated pipework",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 205,
      section: 'Engine Room',
      text:
          "11.33 Fuel and Lube oil tanks and associated pipework, including bunker and lube oil transfer arrangements",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 206,
      section: 'Engine Room',
      text:
          "11.34 Main Switchboard and associated electrical equipment, including emergency switchboard, emergency generator and emergency lighting system",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 207,
      section: 'Engine Room',
      text:
          "11.35 Are emergency bilge pumping arrangements ready for immediate use; is the emergency bilge suction clearly identified and, where fitted, is the emergency overboard discharge valve provided with a notice warning against accidental opening?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 208,
      section: 'Engine Room',
      text:
          "11.36 Are dedicated sludge pumps free from any connection to a direct overboard discharge?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 209,
      section: 'Engine Room',
      text:
          "11.37 Floor boards in ER to be properly fixed by apropriate screws.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 210,
      section: 'Engine Room',
      text:
          "11.38 Are specific warning notices posted to safeguard against the accidental opening of the overboard discharge valve from the oily water separator?",
      responseType: ResponseType.okNotOkNA,
    ),

    // STCW Requirements ---------------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 211,
      section: 'STCW Requirements',
      text:
          "12.1 Is the actual crew composition in accordance with the requirements as per Safe Manning Certificate?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 212,
      section: 'STCW Requirements',
      text:
          "12.2 Are the Master, deck officers, engineer officers and ratings in possession of a respective certificate of competence?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 213,
      section: 'STCW Requirements',
      text:
          "12.3 Do certificates of the crew have endorsements by flag as appropriate?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 214,
      section: 'STCW Requirements',
      text:
          "12.4 Are crewmembers in possession of valid medical examination certificates as appropriate?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 215,
      section: 'STCW Requirements',
      text:
          "12.5 Have new crew members been made familiarised with their duties and the safety equipment onboard?",
      responseType: ResponseType.okNotOkNA,
    ),

    // Critical Components -----------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 216,
      section: 'Critical Components',
      text: "13.1 Stand-by Lub Oil Pump ME",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 217,
      section: 'Critical Components',
      text: "13.2 Stand-by Cooling Water Pumps ME",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 218,
      section: 'Critical Components',
      text: "13.3 Emergency Pump for Steering gear",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 219,
      section: 'Critical Components',
      text: "13.4 Communication Bridge - Engine Room",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 220,
      section: 'Critical Components',
      text: "13.5 Emergency Steering in Engine Room",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 221,
      section: 'Critical Components',
      text: "13.6 Emergency Generator - Starting Test",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 222,
      section: 'Critical Components',
      text: "13.7 Emergency Fire Pump",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 223,
      section: 'Critical Components',
      text: "13.8 Anchoring System",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 224,
      section: 'Critical Components',
      text: "13.9 Quick Closing Valves",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 225,
      section: 'Critical Components',
      text: "13.10 Fire Dampers and Ventilator Flaps",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 226,
      section: 'Critical Components',
      text: "13.11 Safety Equipment",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 227,
      section: 'Critical Components',
      text:
          "13.12 Radio, Emergency and Starting Batteries - Check Density, if applicable",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 228,
      section: 'Critical Components',
      text: "13.13 Fire Detectors - Fire Alarm - Check",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 229,
      section: 'Critical Components',
      text: "13.14 Engine Alarm Instalation - Check Functionlity",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 230,
      section: 'Critical Components',
      text: "13.15 Ventilation Emergency Stop",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 231,
      section: 'Critical Components',
      text: "13.16 Bilge Alarm ER and Bowthruster - Check Functionality",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 232,
      section: 'Critical Components',
      text: "13.17 MOB Outboard Engine - Test Start",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 233,
      section: 'Critical Components',
      text: "13.18 Spare Magnetic Compass - Check",
      responseType: ResponseType.okNotOkNA,
    ),

    //ISM Requirements -----------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 234,
      section: 'ISM Requirements',
      text:
          "14.1 Is the crew familiar with the company's safety and environmental protection policy?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 235,
      section: 'ISM Requirements',
      text: "14.2 Is the ISM manual readily available onboard?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 236,
      section: 'ISM Requirements',
      text:
          "14.3 Is the documentation written in a language understood by the crew?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 237,
      section: 'ISM Requirements',
      text: "14.4 Can senior ship officers identify the responsible company?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 238,
      section: 'ISM Requirements',
      text: "14.5 Can senior officers identify the 'Designated person'?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 239,
      section: 'ISM Requirements',
      text:
          "14.6 Are procedures and data available and updated to establish contact with shore management?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 240,
      section: 'ISM Requirements',
      text:
          "14.7 Are programs for drills and training available and are such actions  recorded?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 241,
      section: 'ISM Requirements',
      text:
          "14.8 Are records available about familiarisation of new crew members?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 242,
      section: 'ISM Requirements',
      text: "14.9 Can the Master show proof of his overriding authority",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 243,
      section: 'ISM Requirements',
      text:
          "14.10 Have Non-conformities been reported to the company and corrective action been taken by the company?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 244,
      section: 'ISM Requirements',
      text: "14.11 Are a maintenance routine and records for it available?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 245,
      section: 'ISM Requirements',
      text:
          "14.12 Is a copy of the DOC with the endorsement for the latest office audit available onboard?",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 246,
      section: 'ISM Requirements',
      text: "14.13 Sailing schedule from berth to berth?",
      responseType: ResponseType.okNotOkNA,
    ),

    // MLC 2006 Requirements -------------------------------------------------------------------------------------------
    ChecklistItem(
      order: 247,
      section: 'MLC 2006 Requirements',
      text:
          "15.1 All seafarers are provided with a copy of the on-board compliant procedures.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 248,
      section: 'MLC 2006 Requirements',
      text: "15.2 Crew under 20 years old (as per SMS of Company)",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 249,
      section: 'MLC 2006 Requirements',
      text: "15.3 Medical certificate valid for all crew",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 250,
      section: 'MLC 2006 Requirements',
      text:
          "15.4 Seafarers Employment Agreement and Collective Bargaining Agreement on board.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 251,
      section: 'MLC 2006 Requirements',
      text:
          "15.5 Working and rest hour are recorded and signed by Master and Seafarers on monthly basis",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 252,
      section: 'MLC 2006 Requirements',
      text: "15.6 Sanitary facilities are clean.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 253,
      section: 'MLC 2006 Requirements',
      text: "15.7 Laundry facilities are in good woring order",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 254,
      section: 'MLC 2006 Requirements',
      text: "15.8 Adequate natural or artificial light available.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 255,
      section: 'MLC 2006 Requirements',
      text:
          "15.9 Mess rooms are properly furnished and equipped(including ongoing facilities for refreshment), taking account of the number of seafarers likely to use them at an one time.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 256,
      section: 'MLC 2006 Requirements',
      text:
          "15.10 The organization and equipment of the catering department permits the provision of adequate, varied and nutritious meals prepared and served in higienic conditions.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 257,
      section: 'MLC 2006 Requirements',
      text:
          "15.11 Food and drinking water is of appropriate quality, nutritional value, quantity and variety, taking in to account the requirements of the ship and the differing culturaland reliqious backgrounds of seafarers on ship.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 258,
      section: 'MLC 2006 Requirements',
      text: "15.12 Ship's Cook is properly trained and instructed",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 259,
      section: 'MLC 2006 Requirements',
      text:
          "15.13 Seafafarers are covered by adequate measures for the protection of their health and have free access to promt and adequate medical care, including essential dental care, whlst working on board.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 260,
      section: 'MLC 2006 Requirements',
      text:
          "15.14 Ship's medical chest and medical equipment are available and maintained. A Medical Guide is available.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 261,
      section: 'MLC 2006 Requirements',
      text:
          "15.15 One seafarer is in charge of medical care and administering medicine or if the ship can reach qualified medical care and medical facilities within 8 hours one seafarer is competent to provide medical first aid. ",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 262,
      section: 'MLC 2006 Requirements',
      text: "15.16 The latest analysis of fresh water",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 263,
      section: 'MLC 2006 Requirements',
      text: "15.17 Risk assessments carried out and documented.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 264,
      section: 'MLC 2006 Requirements',
      text:
          "15.18 Health and safety inspections are carried out regularly and documented.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 265,
      section: 'MLC 2006 Requirements',
      text: "15.19 Safe working practice are implemented.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 266,
      section: 'MLC 2006 Requirements',
      text:
          "15.20 Personal protective equipment is available for suitable task.",
      responseType: ResponseType.okNotOkNA,
    ),
    ChecklistItem(
      order: 267,
      section: 'MLC 2006 Requirements',
      text:
          "15.21 Health and safety inspections are carried out regularly and documented.",
      responseType: ResponseType.okNotOkNA,
    ),
  ],
);
// -------------------------------------------------------

// Можно также собрать все шаблоны в один список для удобства
final List<ChecklistTemplate> allPredefinedTemplates = [
  arrivalPscEngineChecklist,
  technicalInspectionRev08,
  // weeklyLsaChecklist,
  // safetyRoundsChecklist,
];
