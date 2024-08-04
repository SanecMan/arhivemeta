/*
 * Это основной файл куда будут складываться все наши модульные добавления.
 * Добавлять только:
 *	Модули (.dm файлами)
 * Сам этот файл добавлен в tgstation.dme
 *
 * Все Defines файлы лежат в папке "~meta_defines\"
 *
 * Все файлы должны быть в алфавитном порядке
 */

// Modular files (covered with tests)

// BEGIN_INCLUDE
#include "features\additional_circuit\includes.dm"
#include "features\hardsuits\includes.dm"
#include "features\kvass\includes.dm"
#include "features\nanites\includes.dm"
#include "features\smites\includes.dm"
#include "features\soviet_crate\includes.dm"
// END_INCLUDE


//master files (unsorted, TODO: need modularization)

#include "code\_globalvars\lists\names.dm"
#include "code\__HELPERS\names.dm"
#include "interface\interface.dm"
#include "code\modules\clothing\clothing.dm"
#include "code\modules\surgery\organs\tongue.dm"
#include "code\modules\surgery\bodyparts\head.dm"
#include "code\modules\clothing\suits\chaplainsuits.dm"
#include "code\modules\admin\verbs\adminhelp.dm"
#include "code\modules\mob\living\carbon\human\emote.dm"
#include "code\modules\antags\heretic\items\heretic_armor.dm"
#include "code\obj\items\clothing\gloves.dm"
#include "code\obj\items\clothing\masks.dm"
#include "code\datums\components\crafting\makeshift.dm"
#include "code\game\objects\items\devices\radio\radio.dm"
#include "code\game\objects\items\storage\belt.dm"
#include "code\game\objects\items\tools\crowbar.dm"
#include "code\game\objects\items\tools\kitchen.dm"
#include "code\game\objects\items\tools\multitool.dm"
#include "code\game\objects\items\tools\screwdriver.dm"
#include "code\game\objects\items\tools\weldingtool.dm"
#include "code\game\objects\items\tools\wirecutters.dm"
#include "code\game\objects\items\tools\wrench.dm"
#include "code\obj\items\storage\boxes\clothes_boxes.dm"
#include "code\modules\research.dm"
#include "code\obj\structures\display_case.dm"
#include "code\modules\antags\uplink_items.dm"
#include "code\obj\items\clothing\belt.dm"
#include "code\modules\announcers.dm"
#include "code\modules\reagents\chemistry\reagents\nitrium.dm"
#include "code\game\objects\items\maintenance_loot.dm"
#include "code\modules\mob\living\simple_animal\hostile\megafauna\colossus.dm"
#include "code\modules\mob\living\basic\space_fauna\space_dragon\space_dragon.dm"
#include "code\datums\components\crafting\weapon_ammo.dm"
#include "code\modules\ammunition\ballistic\shotgun.dm"
#include "code\modules\projectiles\projectile\bullets\shotgun.dm"
#include "code\modules\projectiles\projectile\beams.dm"
#include "code\modules\mining\lavaland\megafauna_loot.dm"
#include "mapping\_basemap.dm"
#include "code\modules\vending\wardrobes.dm"
#include "code\modules\clothing\head\jobs.dm"
#include "code\modules\clothing\suits\armor.dm"
#include "code\modules\clothing\suits\labcoat.dm"
#include "code\modules\clothing\suits\wintercoats.dm"
#include "code\modules\clothing\under\jobs\rnd.dm"
#include "code\modules\clothing\under\jobs\civilian.dm"
#include "code\modules\clothing\under\jobs\medical.dm"
#include "code\modules\jobs\job_types\medical_doctor.dm"
#include "code\modules\jobs\job_types\research_director.dm"
#include "code\modules\jobs\job_types\chief_medical_officer.dm"
#include "code\modules\jobs\job_types\head_of_personnel.dm"
#include "game\objects\items\storage\garment.dm"
#include "code\modules\hooch.dm"
#include "code\datums\quirks\positive_quirks\augmented.dm"
#include "code\game\machinery\computer\orders\order_items\mining\order_mining.dm"
#include "code\game\objects\structures\crates_lockers\closets\secure\engineering.dm"
#include "code\modules\cargo\markets\market_items\clothing.dm"
#include "code\modules\clothing\suits\wiz_robe.dm"
#include "code\modules\jobs\job_types\clown.dm"
#include "code\modules\uplink\uplink_items\suits.dm"
#include "code\modules\uplink\uplink_items\nukeops.dm"
#include "code\game\machinery\suit_storage_unit.dm"
#include "code\modules\map_vote.dm"
#include "code\modules\hallucination\fake_chat.dm"

//cheburek Car
#include "code\modules\vehicles\cars\cheburek.dm"
#include "code\modules\vehicles\vehicle_actions.dm"
#include "code\modules\cargo\packs\imports.dm"

//buts
#include "code\modules\surgery\organs\internal\butts\butts.dm"
#include "code\modules\surgery\organs\internal\butts\butts_init.dm"

//gay removal (6.21 КоАП РФ)
#include "code\modules\clothing\under\accessories\badges.dm"

//oguzok in kitchen, huh?
#include "code\modules\clothing\under\undersuit.dm"
#include "code\modules\clothing\masks\moustache_ru.dm"

//Testicular_torsion wizard
#include "code\modules\spells\spell_types\touch\testicular_torsion.dm"
#include "code\modules\antags\wizard\equipment\spellbook_entries\offensive.dm"
