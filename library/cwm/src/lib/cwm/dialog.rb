require "yast"

Yast.import "CWM"

module CWM
  # An OOP API and the pieces missing from {YastClass::CWM#show Yast::CWM.show}:
  # - creating and closing a wizard dialog
  # - Back/Abort/Next buttons
  #
  # @see UI::Dialog
  # @see CWM::AbstractWidget
  class Dialog
    include Yast::Logger
    include Yast::I18n
    include Yast::UIShortcuts

    # @return [String,nil] Set a title, or keep the existing title
    abstract_method :title

    # @return [CWM::WidgetTerm]
    abstract_method :contents

    # A shortcut for `.new(*args).run`
    def self.run(*args)
      new(*args).run
    end

    # The entry point.
    # Will open (and close) a wizard dialog unless one already exists.
    # @return [Symbol]
    def run
      if should_open_dialog?
        wizard_create_dialog { run_assuming_open }
      else
        run_assuming_open
      end
    end

    def wizard_create_dialog(&block)
      Yast::Wizard.CreateDialog
      block.call
    ensure
      Yast::Wizard.CloseDialog
    end

    def run_assuming_open
      Yast::CWM.show(
        contents,
        caption:        title,
        back_button:    replace_true(back_button, Yast::Label.BackButton),
        abort_button:   replace_true(abort_button, Yast::Label.AbortButton),
        next_button:    replace_true(next_button, Yast::Label.NextButton),
        skip_store_for: skip_store_for
      )
    end

    def should_open_dialog?
      !Yast::Wizard.IsWizardDialog
    end

    # The :back button
    # @return [String,true,nil] button label,
    #   `true` to use the default label, or `nil` to omit the button
    def back_button
      true
    end

    # The :abort button
    # @return [String,true,nil] button label,
    #   `true` to use the default label, or `nil` to omit the button
    def abort_button
      true
    end

    # The :next button
    # @return [String,true,nil] button label,
    #   `true` to use the default label, or `nil` to omit the button
    def next_button
      true
    end

    # @return [Array<Symbol>]
    def skip_store_for
      []
    end

  private

    def replace_true(value, replacement)
      if value == true
        replacement
      else
        value
      end
    end
  end
end
