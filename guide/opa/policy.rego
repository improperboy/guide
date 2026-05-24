package auth

default allow = false

allow {
    input.user.role == "admin"
}

allow {
    input.user.role == "teacher"
    input.action == "read"
}

allow {
    input.user.role == "student"
    input.action == "view"
}