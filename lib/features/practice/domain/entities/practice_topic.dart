class PracticeTopic {
  const PracticeTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.examRequirement,
    required this.videoId,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final String examRequirement;
  final String videoId;
  final String iconName;
}

const defaultPracticeTopics = [
  PracticeTopic(
    id: 'parallel_park',
    title: 'Paralel Park',
    description: 'Aracı park alanına paralel şekilde park etme manevrası.',
    examRequirement: 'Sınavda aracı 30 saniye içinde park alanına yerleştirmen istenir.',
    videoId: 'Vd9QkWONiT4',
    iconName: 'local_parking',
  ),
  PracticeTopic(
    id: 'hill_start',
    title: 'Yokuşta Kalkış',
    description: 'Yokuşta geri kaymadan kalkış tekniği.',
    examRequirement: 'Aracın geri kaymadan yokuşta kalkması değerlendirilir.',
    videoId: 'Vd9QkWONiT4',
    iconName: 'terrain',
  ),
  PracticeTopic(
    id: 'narrow_turn',
    title: 'Dar Sokak Manevra',
    description: 'Dar alanda dönüş ve manevra kabiliyeti.',
    examRequirement: 'Dar sokakta aracı kontrollü şekilde döndürmen beklenir.',
    videoId: 'Vd9QkWONiT4',
    iconName: 'turn_slight_right',
  ),
  PracticeTopic(
    id: 'reverse_maneuver',
    title: 'Geri Geri Manevra',
    description: 'Geri vites ile kontrollü manevra.',
    examRequirement: 'Belirlenen alanda geri geri manevra yapman istenir.',
    videoId: 'Vd9QkWONiT4',
    iconName: 'u_turn_left',
  ),
];
