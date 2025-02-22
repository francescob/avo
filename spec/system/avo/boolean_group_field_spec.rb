require "rails_helper"

RSpec.describe "BooleanGroupFields", type: :system do
  describe "with regular input" do
    let!(:user) { create :user, roles: {} }

    context "index" do
      it "displays the users name" do
        visit "/avo/resources/users"

        expect(page).to have_text "ROLES"
        expect(page).to have_text "View"
        find("tr[data-resource-id='#{user.id}'] [data-field-id='roles']").find("a", text: "View").hover
        wait_for_loaded

        expect(page).to have_text "Administrator"
        expect(page).to have_text "Manager"
        expect(page).to have_text "Writer"
      end
    end

    context "show" do
      it "displays the users roles" do
        visit "/avo/resources/users/#{user.id}"

        show_roles_popup

        expect(page).to have_text "Roles"
        expect(page).to have_text "Administrator"
        expect(page).to have_text "Manager"
        expect(page).to have_text "Writer"
        expect(page.all(".tippy-content svg")[0][:class]).to have_text "text-red-500"
        expect(page.all(".tippy-content svg")[1][:class]).to have_text "text-red-500"
        expect(page.all(".tippy-content svg")[2][:class]).to have_text "text-red-500"
      end
    end

    context "edit" do
      it "changes the users roles" do
        visit "/avo/resources/users/#{user.id}/edit"

        check "user_roles_admin"
        uncheck "user_roles_manager"
        uncheck "user_roles_writer"

        click_on "Save"
        wait_for_loaded

        user_id = page.find('[data-field-id="id"] [data-slot="value"]').text
        expect(current_path).to eql "/avo/resources/users/#{user_id}"

        show_roles_popup

        expect(page).to have_text "Roles"
        expect(page).to have_text "Administrator"
        expect(page).to have_text "Manager"
        expect(page).to have_text "Writer"
        expect(page.all(".tippy-content svg")[0][:class]).to have_text "text-teal-600"
        expect(page.all(".tippy-content svg")[1][:class]).to have_text "text-red-500"
        expect(page.all(".tippy-content svg")[2][:class]).to have_text "text-red-500"
      end
    end
  end
end

def show_roles_popup
  find("[data-field-id='roles']").find("a", text: "View").hover
end
