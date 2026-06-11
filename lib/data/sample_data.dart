// Data: Sample Data (Dữ liệu mẫu)
import '../models/vocabulary.dart';
import '../models/lesson.dart';

class SampleData {
  // ======= TỪ VỰNG MẪU =======
  static List<Vocabulary> greetingVocab = [
    Vocabulary(
      id: 'v001',
      word: 'Hello',
      pronunciation: '/həˈloʊ/',
      meaning: 'Xin chào',
      example: 'Hello! How are you today?',
      topic: 'Greetings',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v002',
      word: 'Goodbye',
      pronunciation: '/ˌɡʊdˈbaɪ/',
      meaning: 'Tạm biệt',
      example: 'Goodbye! See you tomorrow.',
      topic: 'Greetings',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v003',
      word: 'Thank you',
      pronunciation: '/θæŋk juː/',
      meaning: 'Cảm ơn',
      example: 'Thank you for your help!',
      topic: 'Greetings',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v004',
      word: 'Please',
      pronunciation: '/pliːz/',
      meaning: 'Làm ơn / Xin hãy',
      example: 'Please help me with this.',
      topic: 'Greetings',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v005',
      word: 'Sorry',
      pronunciation: '/ˈsɒri/',
      meaning: 'Xin lỗi',
      example: 'I am sorry for being late.',
      topic: 'Greetings',
      level: 'Beginner',
    ),
  ];

  static List<Vocabulary> travelVocab = [
    Vocabulary(
      id: 'v010',
      word: 'Airport',
      pronunciation: '/ˈeəpɔːt/',
      meaning: 'Sân bay',
      example: 'We arrived at the airport early.',
      topic: 'Travel',
      level: 'Intermediate',
    ),
    Vocabulary(
      id: 'v011',
      word: 'Passport',
      pronunciation: '/ˈpɑːspɔːt/',
      meaning: 'Hộ chiếu',
      example: 'Don\'t forget your passport!',
      topic: 'Travel',
      level: 'Intermediate',
    ),
    Vocabulary(
      id: 'v012',
      word: 'Hotel',
      pronunciation: '/hoʊˈtel/',
      meaning: 'Khách sạn',
      example: 'We stayed at a nice hotel.',
      topic: 'Travel',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v013',
      word: 'Reservation',
      pronunciation: '/ˌrezəˈveɪʃən/',
      meaning: 'Đặt trước / Đặt chỗ',
      example: 'I made a reservation for two.',
      topic: 'Travel',
      level: 'Intermediate',
    ),
    Vocabulary(
      id: 'v014',
      word: 'Itinerary',
      pronunciation: '/aɪˈtɪnəreri/',
      meaning: 'Lịch trình',
      example: 'Please check the itinerary.',
      topic: 'Travel',
      level: 'Advanced',
    ),
  ];

  static List<Vocabulary> businessVocab = [
    Vocabulary(
      id: 'v020',
      word: 'Meeting',
      pronunciation: '/ˈmiːtɪŋ/',
      meaning: 'Cuộc họp',
      example: 'We have a meeting at 9 AM.',
      topic: 'Business',
      level: 'Intermediate',
    ),
    Vocabulary(
      id: 'v021',
      word: 'Deadline',
      pronunciation: '/ˈdedlaɪn/',
      meaning: 'Hạn chót',
      example: 'The deadline is Friday.',
      topic: 'Business',
      level: 'Intermediate',
    ),
    Vocabulary(
      id: 'v022',
      word: 'Presentation',
      pronunciation: '/ˌprezənˈteɪʃən/',
      meaning: 'Bài thuyết trình',
      example: 'I gave a great presentation.',
      topic: 'Business',
      level: 'Advanced',
    ),
    Vocabulary(
      id: 'v023',
      word: 'Strategy',
      pronunciation: '/ˈstræt.ə.dʒi/',
      meaning: 'Chiến lược',
      example: 'We need a new marketing strategy.',
      topic: 'Business',
      level: 'Advanced',
    ),
    Vocabulary(
      id: 'v024',
      word: 'Negotiate',
      pronunciation: '/nɪˈɡoʊ.ʃi.eɪt/',
      meaning: 'Đàm phán',
      example: 'Let\'s negotiate the contract.',
      topic: 'Business',
      level: 'Advanced',
    ),
  ];

  static List<Vocabulary> foodVocab = [
    Vocabulary(
      id: 'v030',
      word: 'Restaurant',
      pronunciation: '/ˈrest.ər.ɒnt/',
      meaning: 'Nhà hàng',
      example: 'Let\'s go to a restaurant.',
      topic: 'Food',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v031',
      word: 'Menu',
      pronunciation: '/ˈmenjuː/',
      meaning: 'Thực đơn',
      example: 'Can I see the menu, please?',
      topic: 'Food',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v032',
      word: 'Delicious',
      pronunciation: '/dɪˈlɪʃ.əs/',
      meaning: 'Ngon / Tuyệt vời',
      example: 'This food is delicious!',
      topic: 'Food',
      level: 'Beginner',
    ),
    Vocabulary(
      id: 'v033',
      word: 'Vegetarian',
      pronunciation: '/ˌvedʒ.ɪˈteər.i.ən/',
      meaning: 'Ăn chay',
      example: 'I am a vegetarian.',
      topic: 'Food',
      level: 'Intermediate',
    ),
    Vocabulary(
      id: 'v034',
      word: 'Cuisine',
      pronunciation: '/kwɪˈziːn/',
      meaning: 'Ẩm thực',
      example: 'I love Vietnamese cuisine.',
      topic: 'Food',
      level: 'Advanced',
    ),
  ];

  // ======= BÀI HỌC MẪU =======
  static List<Lesson> getAllLessons() {
    return [
      Lesson(
        id: 'l001',
        title: 'Greetings & Introductions',
        description: 'Học cách chào hỏi và giới thiệu bản thân trong tiếng Anh.',
        topic: 'Daily Life',
        level: 'Beginner',
        imageEmoji: '👋',
        vocabularies: greetingVocab,
        progress: 60,
      ),
      Lesson(
        id: 'l002',
        title: 'Travel & Tourism',
        description: 'Từ vựng và mẫu câu hữu ích khi đi du lịch nước ngoài.',
        topic: 'Travel',
        level: 'Intermediate',
        imageEmoji: '✈️',
        vocabularies: travelVocab,
        progress: 40,
      ),
      Lesson(
        id: 'l003',
        title: 'Business English',
        description: 'Tiếng Anh chuyên nghiệp dùng trong môi trường công sở.',
        topic: 'Business',
        level: 'Advanced',
        imageEmoji: '💼',
        vocabularies: businessVocab,
        progress: 20,
      ),
      Lesson(
        id: 'l004',
        title: 'Food & Dining',
        description: 'Từ vựng về ẩm thực, nhà hàng và việc gọi đồ ăn.',
        topic: 'Food',
        level: 'Beginner',
        imageEmoji: '🍽️',
        vocabularies: foodVocab,
        progress: 80,
      ),
      Lesson(
        id: 'l005',
        title: 'Technology & Internet',
        description: 'Từ vựng về công nghệ, internet và thiết bị điện tử.',
        topic: 'Technology',
        level: 'Intermediate',
        imageEmoji: '💻',
        vocabularies: greetingVocab,
        progress: 10,
      ),
      Lesson(
        id: 'l006',
        title: 'Health & Medicine',
        description: 'Từ vựng về sức khỏe, bệnh viện và chăm sóc y tế.',
        topic: 'Health',
        level: 'Intermediate',
        imageEmoji: '🏥',
        vocabularies: businessVocab,
        progress: 35,
      ),
    ];
  }

  // ======= QUIZ QUESTIONS =======
  static List<Map<String, dynamic>> getQuizQuestions() {
    return [
      {
        'question': 'What does "Hello" mean in Vietnamese?',
        'options': ['Tạm biệt', 'Xin chào', 'Cảm ơn', 'Xin lỗi'],
        'correctIndex': 1,
        'word': 'Hello',
      },
      {
        'question': 'What does "Thank you" mean?',
        'options': ['Không có gì', 'Xin chào', 'Cảm ơn', 'Tạm biệt'],
        'correctIndex': 2,
        'word': 'Thank you',
      },
      {
        'question': 'What does "Airport" mean?',
        'options': ['Cảng biển', 'Sân bay', 'Ga tàu', 'Bến xe'],
        'correctIndex': 1,
        'word': 'Airport',
      },
      {
        'question': 'Which word means "Đàm phán"?',
        'options': ['Meeting', 'Strategy', 'Negotiate', 'Deadline'],
        'correctIndex': 2,
        'word': 'Negotiate',
      },
      {
        'question': 'What does "Delicious" mean?',
        'options': ['Ngon', 'Đắt tiền', 'Ngọt ngào', 'Chua'],
        'correctIndex': 0,
        'word': 'Delicious',
      },
    ];
  }
}
