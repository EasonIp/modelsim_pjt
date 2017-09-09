library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;
ENTITY sina IS 
    PORT( CLK:IN STD_LOGIC;
          dout:OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END;

ARCHITECTURE arch OF sina IS
  signal q1: integer range 0 to 400;
  signal dat: integer range -200 to 200;
  BEGIN
   PROCESS(CLK)
      BEGIN
       IF CLK'EVENT AND CLK='1' THEN 
          if q1=399 then  
               q1<=0;
          else 
               q1<=q1+1;
          end if;
case q1 is
when    0=>dat<=0;
when    1=>dat<=3;
when    2=>dat<=6;
when    3=>dat<=9;
when    4=>dat<=12;
when    5=>dat<=15;
when    6=>dat<=18;
when    7=>dat<=21;
when    8=>dat<=25;
when    9=>dat<=28;
when    10=>dat<=31;
when    11=>dat<=34;
when    12=>dat<=37;
when    13=>dat<=40;
when    14=>dat<=43;
when    15=>dat<=46;
when    16=>dat<=49;
when    17=>dat<=52;
when    18=>dat<=55;
when    19=>dat<=58;
when    20=>dat<=61;
when    21=>dat<=64;
when    22=>dat<=67;
when    23=>dat<=70;
when    24=>dat<=73;
when    25=>dat<=76;
when    26=>dat<=79;
when    27=>dat<=82;
when    28=>dat<=85;
when    29=>dat<=87;
when    30=>dat<=90;
when    31=>dat<=93;
when    32=>dat<=96;
when    33=>dat<=99;
when    34=>dat<=101;
when    35=>dat<=104;
when    36=>dat<=107;
when    37=>dat<=109;
when    38=>dat<=112;
when    39=>dat<=115;
when    40=>dat<=117;
when    41=>dat<=120;
when    42=>dat<=122;
when    43=>dat<=125;
when    44=>dat<=127;
when    45=>dat<=129;
when    46=>dat<=132;
when    47=>dat<=134;
when    48=>dat<=136;
when    49=>dat<=139;
when    50=>dat<=141;
when    51=>dat<=143;
when    52=>dat<=145;
when    53=>dat<=147;
when    54=>dat<=150;
when    55=>dat<=152;
when    56=>dat<=154;
when    57=>dat<=156;
when    58=>dat<=158;
when    59=>dat<=159;
when    60=>dat<=161;
when    61=>dat<=163;
when    62=>dat<=165;
when    63=>dat<=167;
when    64=>dat<=168;
when    65=>dat<=170;
when    66=>dat<=172;
when    67=>dat<=173;
when    68=>dat<=175;
when    69=>dat<=176;
when    70=>dat<=178;
when    71=>dat<=179;
when    72=>dat<=180;
when    73=>dat<=182;
when    74=>dat<=183;
when    75=>dat<=184;
when    76=>dat<=185;
when    77=>dat<=187;
when    78=>dat<=188;
when    79=>dat<=189;
when    80=>dat<=190;
when    81=>dat<=191;
when    82=>dat<=192;
when    83=>dat<=192;
when    84=>dat<=193;
when    85=>dat<=194;
when    86=>dat<=195;
when    87=>dat<=195;
when    88=>dat<=196;
when    89=>dat<=197;
when    90=>dat<=197;
when    91=>dat<=198;
when    92=>dat<=198;
when    93=>dat<=198;
when    94=>dat<=199;
when    95=>dat<=199;
when    96=>dat<=199;
when    97=>dat<=199;
when    98=>dat<=199;
when    99=>dat<=199;
when    100=>dat<=200;
when    101=>dat<=199;
when    102=>dat<=199;
when    103=>dat<=199;
when    104=>dat<=199;
when    105=>dat<=199;
when    106=>dat<=199;
when    107=>dat<=198;
when    108=>dat<=198;
when    109=>dat<=198;
when    110=>dat<=197;
when    111=>dat<=197;
when    112=>dat<=196;
when    113=>dat<=195;
when    114=>dat<=195;
when    115=>dat<=194;
when    116=>dat<=193;
when    117=>dat<=192;
when    118=>dat<=192;
when    119=>dat<=191;
when    120=>dat<=190;
when    121=>dat<=189;
when    122=>dat<=188;
when    123=>dat<=187;
when    124=>dat<=185;
when    125=>dat<=184;
when    126=>dat<=183;
when    127=>dat<=182;
when    128=>dat<=180;
when    129=>dat<=179;
when    130=>dat<=178;
when    131=>dat<=176;
when    132=>dat<=175;
when    133=>dat<=173;
when    134=>dat<=172;
when    135=>dat<=170;
when    136=>dat<=168;
when    137=>dat<=167;
when    138=>dat<=165;
when    139=>dat<=163;
when    140=>dat<=161;
when    141=>dat<=159;
when    142=>dat<=158;
when    143=>dat<=156;
when    144=>dat<=154;
when    145=>dat<=152;
when    146=>dat<=150;
when    147=>dat<=147;
when    148=>dat<=145;
when    149=>dat<=143;
when    150=>dat<=141;
when    151=>dat<=139;
when    152=>dat<=136;
when    153=>dat<=134;
when    154=>dat<=132;
when    155=>dat<=129;
when    156=>dat<=127;
when    157=>dat<=125;
when    158=>dat<=122;
when    159=>dat<=120;
when    160=>dat<=117;
when    161=>dat<=115;
when    162=>dat<=112;
when    163=>dat<=109;
when    164=>dat<=107;
when    165=>dat<=104;
when    166=>dat<=101;
when    167=>dat<=99;
when    168=>dat<=96;
when    169=>dat<=93;
when    170=>dat<=90;
when    171=>dat<=87;
when    172=>dat<=85;
when    173=>dat<=82;
when    174=>dat<=79;
when    175=>dat<=76;
when    176=>dat<=73;
when    177=>dat<=70;
when    178=>dat<=67;
when    179=>dat<=64;
when    180=>dat<=61;
when    181=>dat<=58;
when    182=>dat<=55;
when    183=>dat<=52;
when    184=>dat<=49;
when    185=>dat<=46;
when    186=>dat<=43;
when    187=>dat<=40;
when    188=>dat<=37;
when    189=>dat<=34;
when    190=>dat<=31;
when    191=>dat<=28;
when    192=>dat<=25;
when    193=>dat<=21;
when    194=>dat<=18;
when    195=>dat<=15;
when    196=>dat<=12;
when    197=>dat<=9;
when    198=>dat<=6;
when    199=>dat<=3;
when    200=>dat<=0;
when    201=>dat<=-4;
when    202=>dat<=-7;
when    203=>dat<=-10;
when    204=>dat<=-13;
when    205=>dat<=-16;
when    206=>dat<=-19;
when    207=>dat<=-22;
when    208=>dat<=-26;
when    209=>dat<=-29;
when    210=>dat<=-32;
when    211=>dat<=-35;
when    212=>dat<=-38;
when    213=>dat<=-41;
when    214=>dat<=-44;
when    215=>dat<=-47;
when    216=>dat<=-50;
when    217=>dat<=-53;
when    218=>dat<=-56;
when    219=>dat<=-59;
when    220=>dat<=-62;
when    221=>dat<=-65;
when    222=>dat<=-68;
when    223=>dat<=-71;
when    224=>dat<=-74;
when    225=>dat<=-77;
when    226=>dat<=-80;
when    227=>dat<=-83;
when    228=>dat<=-86;
when    229=>dat<=-88;
when    230=>dat<=-91;
when    231=>dat<=-94;
when    232=>dat<=-97;
when    233=>dat<=-100;
when    234=>dat<=-102;
when    235=>dat<=-105;
when    236=>dat<=-108;
when    237=>dat<=-110;
when    238=>dat<=-113;
when    239=>dat<=-116;
when    240=>dat<=-118;
when    241=>dat<=-121;
when    242=>dat<=-123;
when    243=>dat<=-126;
when    244=>dat<=-128;
when    245=>dat<=-130;
when    246=>dat<=-133;
when    247=>dat<=-135;
when    248=>dat<=-137;
when    249=>dat<=-140;
when    250=>dat<=-142;
when    251=>dat<=-144;
when    252=>dat<=-146;
when    253=>dat<=-148;
when    254=>dat<=-151;
when    255=>dat<=-153;
when    256=>dat<=-155;
when    257=>dat<=-157;
when    258=>dat<=-159;
when    259=>dat<=-160;
when    260=>dat<=-162;
when    261=>dat<=-164;
when    262=>dat<=-166;
when    263=>dat<=-168;
when    264=>dat<=-169;
when    265=>dat<=-171;
when    266=>dat<=-173;
when    267=>dat<=-174;
when    268=>dat<=-176;
when    269=>dat<=-177;
when    270=>dat<=-179;
when    271=>dat<=-180;
when    272=>dat<=-181;
when    273=>dat<=-183;
when    274=>dat<=-184;
when    275=>dat<=-185;
when    276=>dat<=-186;
when    277=>dat<=-188;
when    278=>dat<=-189;
when    279=>dat<=-190;
when    280=>dat<=-191;
when    281=>dat<=-192;
when    282=>dat<=-193;
when    283=>dat<=-193;
when    284=>dat<=-194;
when    285=>dat<=-195;
when    286=>dat<=-196;
when    287=>dat<=-196;
when    288=>dat<=-197;
when    289=>dat<=-198;
when    290=>dat<=-198;
when    291=>dat<=-199;
when    292=>dat<=-199;
when    293=>dat<=-199;
when    294=>dat<=-200;
when    295=>dat<=-200;
when    296=>dat<=-200;
when    297=>dat<=-200;
when    298=>dat<=-200;
when    299=>dat<=-200;
when    300=>dat<=-200;
when    301=>dat<=-200;
when    302=>dat<=-200;
when    303=>dat<=-200;
when    304=>dat<=-200;
when    305=>dat<=-200;
when    306=>dat<=-200;
when    307=>dat<=-199;
when    308=>dat<=-199;
when    309=>dat<=-199;
when    310=>dat<=-198;
when    311=>dat<=-198;
when    312=>dat<=-197;
when    313=>dat<=-196;
when    314=>dat<=-196;
when    315=>dat<=-195;
when    316=>dat<=-194;
when    317=>dat<=-193;
when    318=>dat<=-193;
when    319=>dat<=-192;
when    320=>dat<=-191;
when    321=>dat<=-190;
when    322=>dat<=-189;
when    323=>dat<=-188;
when    324=>dat<=-186;
when    325=>dat<=-185;
when    326=>dat<=-184;
when    327=>dat<=-183;
when    328=>dat<=-181;
when    329=>dat<=-180;
when    330=>dat<=-179;
when    331=>dat<=-177;
when    332=>dat<=-176;
when    333=>dat<=-174;
when    334=>dat<=-173;
when    335=>dat<=-171;
when    336=>dat<=-169;
when    337=>dat<=-168;
when    338=>dat<=-166;
when    339=>dat<=-164;
when    340=>dat<=-162;
when    341=>dat<=-160;
when    342=>dat<=-159;
when    343=>dat<=-157;
when    344=>dat<=-155;
when    345=>dat<=-153;
when    346=>dat<=-151;
when    347=>dat<=-148;
when    348=>dat<=-146;
when    349=>dat<=-144;
when    350=>dat<=-142;
when    351=>dat<=-140;
when    352=>dat<=-137;
when    353=>dat<=-135;
when    354=>dat<=-133;
when    355=>dat<=-130;
when    356=>dat<=-128;
when    357=>dat<=-126;
when    358=>dat<=-123;
when    359=>dat<=-121;
when    360=>dat<=-118;
when    361=>dat<=-116;
when    362=>dat<=-113;
when    363=>dat<=-110;
when    364=>dat<=-108;
when    365=>dat<=-105;
when    366=>dat<=-102;
when    367=>dat<=-100;
when    368=>dat<=-97;
when    369=>dat<=-94;
when    370=>dat<=-91;
when    371=>dat<=-88;
when    372=>dat<=-86;
when    373=>dat<=-83;
when    374=>dat<=-80;
when    375=>dat<=-77;
when    376=>dat<=-74;
when    377=>dat<=-71;
when    378=>dat<=-68;
when    379=>dat<=-65;
when    380=>dat<=-62;
when    381=>dat<=-59;
when    382=>dat<=-56;
when    383=>dat<=-53;
when    384=>dat<=-50;
when    385=>dat<=-47;
when    386=>dat<=-44;
when    387=>dat<=-41;
when    388=>dat<=-38;
when    389=>dat<=-35;
when    390=>dat<=-32;
when    391=>dat<=-29;
when    392=>dat<=-26;
when    393=>dat<=-22;
when    394=>dat<=-19;
when    395=>dat<=-16;
when    396=>dat<=-13;
when    397=>dat<=-10;
when    398=>dat<=-7;
when    399=>dat<=-4;


when   others=> dat<=0;
end case;
 dout<= conv_std_logic_vector (dat,16);
END IF;
 
  
   END PROCESS;
END;