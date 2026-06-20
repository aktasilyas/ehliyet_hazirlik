-- Ehliyet Hazırlık — Soru Bankası (Supabase)
-- Bölüm 7.1 mimari dokümanına göre

create extension if not exists "pgcrypto";

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  category text not null check (category in ('traffic', 'first_aid', 'engine', 'environment')),
  difficulty int not null check (difficulty between 1 and 3),
  year int check (year between 2018 and 2025),
  question_text text not null,
  option_a text not null,
  option_b text not null,
  option_c text not null,
  option_d text not null,
  correct_option char(1) not null check (correct_option in ('A', 'B', 'C', 'D')),
  explanation text,
  image_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists idx_questions_category on public.questions (category);
create index if not exists idx_questions_year on public.questions (year);
create index if not exists idx_questions_active on public.questions (is_active);

alter table public.questions enable row level security;

create policy "questions_read_active"
  on public.questions
  for select
  using (is_active = true);

-- Örnek sorular (geliştirme için — production'da genişletilmeli)
insert into public.questions (
  category, difficulty, year, question_text,
  option_a, option_b, option_c, option_d, correct_option, explanation
) values
(
  'traffic', 1, 2024,
  'Aşağıdaki trafik işaretlerinden hangisi "Dur" anlamına gelir?',
  'Kırmızı ışık', 'Yeşil ışık', 'Sarı ışık', 'Mavi ışık',
  'A', 'Kırmızı ışık durmayı ifade eder.'
),
(
  'first_aid', 2, 2023,
  'Bilinçsiz bir kazazedeye ilk müdahalede ne yapılmalıdır?',
  'Su içirilir', 'Hava yolu açıklığı kontrol edilir', 'Ayakta tutulur', 'Koşulur',
  'B', 'İlk yardımda önce hava yolu açıklığı kontrol edilir.'
),
(
  'engine', 1, null,
  'Motor yağı seviyesi hangi durumda kontrol edilmelidir?',
  'Motor sıcakken', 'Motor soğukken', 'Araç hareket halindeyken', 'Hiçbir zaman',
  'B', 'Yağ seviyesi motor soğukken ölçülür.'
),
(
  'environment', 2, 2022,
  'Araç egzoz emisyonlarını azaltmak için aşağıdakilerden hangisi yapılmalıdır?',
  'Rölantide uzun süre beklemek', 'Düzenli bakım yaptırmak', 'Lastik basıncını düşürmek', 'Hız limitini aşmak',
  'B', 'Düzenli bakım emisyonu azaltır.'
);
