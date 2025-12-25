package com.example.core.utils.validator

class Validator {
    companion object{
        fun isValidEmail(email: String): Boolean {
            return email.matches(Regex("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\$"))
        }
    }
}