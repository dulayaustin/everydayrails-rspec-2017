require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create(
      first_name: "John",
      last_name: "Doe",
      email: "johndoe@example.com",
      password: "password"
    )
    @project = @user.projects.create(name: "Test Project")
  end

  it "is valid with a user, project and message" do
    note = Note.new(
      user: @user,
      project: @project,
      message: "Hello world!"
    )

    expect(note).to be_valid
  end

  it "is invalid without message" do
    note = Note.new(message: nil)

    note.valid?

    expect(note.errors[:message]).to include("can't be blank")
  end

  describe ".search" do
    before do
      @note1 = @project.notes.create(
        message: "This is the first note",
        user: @user
      )
      @note2 = @project.notes.create(
        message: "This is the second note",
        user: @user
      )
      @note3 = @project.notes.create(
        message: "First, preheat the oven",
        user: @user
      )
    end

    context "when a match is found" do
      it "return notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
      end
    end

    context "when no match is found" do
      it "return an empty collection when no results are found" do
        expect(Note.search("hello")).to be_empty
      end
    end
  end
end
