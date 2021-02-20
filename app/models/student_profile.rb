class StudentProfile < ApplicationRecord
  belongs_to :student

  validates :name, presence: true, allow_nil: false,
            length: {maximum: Settings.validations.student_profile.name.max_length}
  validates :email, presence: true, allow_nil: false,
            length: {maximum: Settings.validations.student_profile.email.max_length},
            format: {with: Settings.validations.student_profile.email.regex},
            uniqueness: {case_sensitive: false}
  validates :identity_card_number, presence: true, allow_nil: false,
            length: {
              minimum: Settings.validations.student_profile.identity_number.min_length,
              maximum: Settings.validations.student_profile.identity_number.max_length
            },
            format: {with: Settings.validations.student_profile.identity_number.regex},
            uniqueness: {case_sensitive: false}
  validates :phone_number, presence: true, allow_nil: false,
            format: {with: Settings.validations.student_profile.phone_number.regex}
  validates :class_name, presence: true, allow_nil: false,
            length: {maximum: Settings.validations.student_profile.class_name.max_length,
                    minimum: Settings.validations.student_profile.class_name.min_length}
  validates :address, presence: true, allow_nil: false,
            length: {maximum: Settings.validations.student_profile.address.max_length, 
                    minimum: Settings.validations.student_profile.address.min_length}
  validates :date_of_birth, presence: true, allow_nil: false
  validates :gender, presence: true, inclusion: { in: ['nam', 'nu']}, allow_nil: false
  validates :avatar, presence: true, allow_nil: true

end