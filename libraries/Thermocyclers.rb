# frozen_string_literal: true

# Library for handling thermocyclers, including qPCR thermocyclers
#
# @author Devin Strickland <strcklnd@uw.edu>

needs 'Thermocyclers/TestThermocycler'
needs 'Thermocyclers/BioRadCFX96'
needs 'Thermocyclers/MiniPCRMini16'

# Helper module for standard thermocycler procedures
#
# @author Devin Strickland <strcklnd@uw.edu>
# @author Eriberto Lopez <elopez3@uw.edu>
# @note methods originally deployed as `QPCR_ThermocyclerLib`
#   on UW BIOFAB production 10/05/18
module ThermocyclerHelper
  # Steps for setting up a proram in a thermocycler
  #
  # @param thermocycler [Thermocycler]
  # @param program [PCRProgram]
  # @param composition [PCRComposition]
  def set_up_program(thermocycler:, program:, composition:)
    show do
      title "Set Up #{thermocycler.model} Thermocycler"

      if thermocycler.respond_to?(:open_software)
        note thermocycler.open_software
        image thermocycler.open_software_image
        separator
      end

      if thermocycler.respond_to?(:set_dye)
        note thermocycler.set_dye(composition: composition)
        separator
      end

      if thermocycler.respond_to?(:setup_workspace_image)
        image thermocycler.setup_workspace_image
        separator
      end

      note thermocycler.select_program_template(program: program)
      image thermocycler.setup_program_image
      separator

      if thermocycler.respond_to?(:set_dye)
        note thermocycler.select_layout_template(program: program)
        image thermocycler.setup_plate_layout_image
      end
    end
  end

  # Steps for loading physical tubes or plates into a thermocycler
  #
  # @param thermocycler [Thermocycler]
  # @param items [Item, Array<Item>]
  # @param filename [String] the filename to safe the experiment file
  def load_plate_and_start_run(thermocycler:, items: [], filename: nil)
    # Normalize the presentation of `items`
    items = [items] if items.respond_to?(:collection?)
    plate = single_96well_plate?(items)

    show do
      title "Start Run on #{thermocycler.model} Thermocycler"

      note thermocycler.open_lid
      image thermocycler.open_lid_image
      separator

      # TODO: Make this work for plates, stripwells, and individual tubes
      if plate
        note thermocycler.place_plate_in_instrument(plate: items.first)
        warning thermocycler.confirm_plate_orientation
      else
        note 'Load the PCR tubes into the metal block'
      end
      separator

      note thermocycler.close_lid
      image thermocycler.close_lid_image
      separator

      note thermocycler.start_run
      if filename.present? && thermocycler.respond_to?(:save_experiment_file)
        note thermocycler.save_experiment_file(filename: filename)
      end
    end
  end

  # Export the measurements, if a qPCR thermocycler
  #
  # @param thermocycler [Thermocycler]
  def export_measurements(thermocycler:)
    return unless thermocycler.respond_to?(:export_measurements)

    show do
      title 'Export Measurements'

      note 'Once the run has finished, export the measurements'
      note thermocycler.export_measurements
      image thermocycler.export_results_image
    end
  end

  # TODO: A method from Eriberto Lopez's code that I haven't implemented yet
  # def upload_measurments(experiment_name)
  #   upload_filename = experiment_name + " - Quantification Summary_0.csv" # Suffix of file will always be the same
  #   up_show, up_sym = upload_show(upload_path = EXPORT_FILEPATH, upload_filename)
  #   if debug
  #     upload = Upload.find(11278) # Dummy data set
  #   else
  #     upload = find_upload_from_show(up_show, up_sym)
  #   end
  #   return upload
  # end

  private

  # Test whether an array of items is a single 96 well plate
  #
  # @param items [Array<Item>]
  # @return [Boolean]
  def single_96well_plate?(items)
    items.length == 1 && is_96well_plate?(items.first)
  end

  # Test whether an item is a 96 well plate
  #
  # @param item [Item]
  # @return [Boolean]
  def is_96well_plate?(item)
    item.collection? && item.capacity == 96
  end
end

# Factory class for building thermocycler objects
#
# @author Devin Strickland <strcklnd@uw.edu>
class ThermocyclerFactory
  # Instantiates a new `Thermocycler`
  #
  # @param model [String] the `MODEL` of the thermocycler. Must match the
  #   constant `MODEL` in an exisiting thermocycler class.
  # @return [Thermocycler]
  def self.build(model:)
    case model
    when TestThermocycler::MODEL
      TestThermocycler.new
    when BioRadCFX96::MODEL
      BioRadCFX96.new
    when MiniPCRMini16::MODEL
      MiniPCRMini16.new
    else
      msg = "Unrecognized Thermocycler Model: #{model}"
      raise ThermocyclerInputError, msg
    end
  end
end

class ThermocyclerInputError < ProtocolError; end
