# frozen_string_literal: true

class Api::V1::Users::ProgramsController < ApplicationController
  before_action :set_user
  before_action :set_program, only: %i[destroy]

  # GET api/v1/users/:user_id/programs
  def index
    programs = @user.programs.page(page)
    render json: {
      programs: {
        current_page: programs.current_page,
        pages: programs.total_pages,
        count: programs.count,
        items: programs,
        is_last: programs.last_page?
      }
    }
  end

  # POST api/v1/users/:user_id/programs
  def create
    program = Program.find subscribe_params[:program_id]
    render json: {status: :subscribed} if Programs::Users.new(program, @user).subscribe
  end

  # DELETE api/v1/users/:user_id/programs/:id
  def destroy
    render json: {status: :unsubscribed} if Programs::Users.new(@program, @user).unsubscribe
  end

  private

  def set_user
    @user = User.find params[:user_id]
  end

  def set_program
    @program = Program.find params[:id]
  end

  def subscribe_params
    params.require(:subscribe).permit(:program_id)
  end


end
