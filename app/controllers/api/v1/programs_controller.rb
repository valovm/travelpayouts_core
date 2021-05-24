# frozen_string_literal: true

class Api::V1::ProgramsController < ApplicationController
  before_action :set_program, only: %i[show]

  def index
    programs = Programs::List.new.call(params[:term]).page(page)
    render json: {
      products: {
        current_page: programs.current_page,
        pages: programs.total_pages,
        count: programs.count,
        items: programs,
        is_last: programs.last_page?
      }
    }
  end

  def show
    render json: @program
  end

  private

  def set_program
    @program = Program.find params[:id]
  end

end