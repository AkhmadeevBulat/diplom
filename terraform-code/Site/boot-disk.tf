# Загрузочный диск для Бастион-сервера

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = "fd8tvc3529h2cpjvpkr5"
}


# Загрузочный диск для WEB-сервера 1

resource "yandex_compute_disk" "boot-disk-2" {
  name     = "boot-disk-2"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "10"
  image_id = "fd8tvc3529h2cpjvpkr5"
}


# Загрузочный диск для WEB-сервера 2

resource "yandex_compute_disk" "boot-disk-3" {
  name     = "boot-disk-3"
  type     = "network-hdd"
  zone     = "ru-central1-d"
  size     = "10"
  image_id = "fd8tvc3529h2cpjvpkr5"
}