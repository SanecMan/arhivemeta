## Module ID: TRANSLATE_PETS_COMMANDS

### Description:

Питомцы теперь слушаются коммандам на Русском. Например, король Крыс может таким образом повелевать своими мышами.
Некоторые слова специально сокращены, чтобы код мог работать с разными окончаниями.
Например "куса" и "куси" будет воспринято в словах:
- укуси
- покусай 
- кусай и тд


### TG Proc/File Changes:

- code/datums/components/pet_commands/fetch.dm
- code/datums/components/pet_commands/pet_commands_basic.dm
- code/modules/mob/living/basic/space_fauna/regal_rat/regal_rat_actions.dm
- code/modules/mob/living/basic/pets/dog/_dog.dm
- code/modules/mob/living/basic/jungle/leaper/leaper_ai.dm
- code/modules/mob/living/basic/icemoon/wolf/wolf_extras.dm
- code/modules/mob/living/basic/farm_animals/bee/bee_ai_behavior.dm
- code/modules/mob/living/basic/pets/orbie/orbie_ai.dm
- code/modules/mob/living/basic/heretic/star_gazer.dm
- code/modules/mob/living/basic/jungle/seedling/seedling_ai.dm
- code/modules/mob/living/basic/minebots/minebot_ai.dm
- code/modules/mob/living/basic/lavaland/gutlunchers/gutlunchers_ai.dm
- code/modules/mob/living/basic/pets/pet_cult/pet_cult_ai.dm
- code/modules/mob/living/basic/bots/cleanbot/cleanbot_ai.dm
- code/modules/mob/living/basic/lavaland/goldgrub/goldgrub_ai.dm
- code/modules/mob/living/basic/slime/ai/pet_command.dm


### Modular Overrides:

- N/A


### Defines:

- N/A


### TGUI Files:

- N/A


### Credits:

- N/A
