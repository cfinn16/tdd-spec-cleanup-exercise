require "rails_helper"

RSpec.describe Invitation do
  describe "callbacks" do
    it "invites the user after saving with valid data" do
      team = Team.new(name: "A fine team")
      new_user = User.new(email: "rookie@example.com")
      invitation = Invitation.new(team: team, user: new_user)

      invitation.save

      expect(new_user.invited).to eq true
    end

    it "does not save the invitation and does not invite the user with invalid data" do
      new_user = User.new(email: "rookie@example.com")
      invitation = Invitation.new(team: nil, user: new_user)

      invitation.save

      expect(invitation.valid?).to eq false
      expect(invitation.new_record?).to eq true

      expect(new_user.invited).not_to eq true
    end
  end

  describe "#event_log_statement" do
    it "logs the name of the team and the invitee when saved" do
      team = Team.new(name: "A fine team")
      new_user = User.new(email: "rookie@example.com")
      invitation = Invitation.new(team: team, user: new_user)

      invitation.save

      expect(invitation.event_log_statement).to eq("rookie@example.com invited to A fine team")
    end

    it "is prefaced by the wording PENDING when the record is not saved but valid" do
      team = Team.new(name: "A fine team")
      new_user = User.new(email: "rookie@example.com")
      invitation = Invitation.new(team: team, user: new_user)

      expect(invitation.event_log_statement).to eq("PENDING - rookie@example.com invited to A fine team")
    end

    it "returns INVALID when the record is not saved and not valid" do
      invitation = Invitation.new(team: nil, user: nil)
        expect(invitation.event_log_statement).to eq("INVALID")
    end
  end
end
