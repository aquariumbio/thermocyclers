# TODO: Make a qPCR MixIn
# TODO: Can duck type thermocycler on qPCR MixIn when available

class AbstractThermocycler

  # CONSTANTS that really shouldn't ever change
  # Should be overriden in concrete class
  MODEL = ""
  PROGRAM_EXT = ""
  LAYOUT_EXT =  ""
  SOFTWARE_NAME = "thermocycler software"
  
  private_constant :MODEL, :PROGRAM_EXT, :LAYOUT_EXT, :SOFTWARE_NAME

  attr_reader :params

  # Instantiates the class and sets the `@params` insteance variable
  #
  # @return [Thermocycler]
  def initialize()
    @params = default_params.update(user_defined_params)
  end

  # Lab-specific, user-defined parameters
  #
  # @note Should be overriden in concrete class
  # @return [Hash]
  def user_defined_params()
    {}
  end

  # The model of the thermocycler
  #
  # @return [String]
  def model()
    self.class.const_get(:MODEL)
  end

  # The name of the software that controls the thermocycler
  #
  # @return [String]
  def software_name()
    self.class.const_get(:SOFTWARE_NAME)
  end

  ########## Language Methods
  # These methods are not very specific and will probably need to be overridden
  #   in the concrete classes.

  # Instructions for opening the software that controls the thermocycler
  #
  # @return [String]
  def open_software()
    "Open #{software_name}"
  end

  # Instructions for setting the dye channel on a qPCR thermocycler
  #
  # @param composition [PCRComposition]
  # @param dye_name [String] can be supplied instead of a `PCRComposition`
  # @return [String]
  # @todo should be moved to MixIn
  def set_dye(composition: nil, dye_name: nil)
    dye_name = composition.dye.try(:input_name) || dye_name
    "Choose <b>#{dye_name}</b> as the dye"
  end

  # Instructions for selecting the PCR program template in the software
  #
  # @param program [PCRProgram]
  # @return [String]
  def select_program_template(program:)
    file = program_template_file(program: program)
    "Choose the program template <b>#{file}</b>"
  end

  # Instructions for selecting the plate layout template in the software
  #
  # @param program [PCRProgram]
  # @return [String]
  def select_layout_template(program:)
    file = layout_template_file(program: program)
    "Choose the layout template <b>#{file}</b>"
  end

  # Instructions for placing a plate in the instrument
  #
  # @param plate [Collection]
  # @return [String]
  def place_plate_in_instrument(plate:)
    "Place plate #{plate} in the thermocycler"
  end

  # Instructions for confirming the orientation of a plate in the instrument
  #
  # @return [String]
  def confirm_plate_orientation()
    "MAKE SURE THAT THE PLATE IS IN THE CORRECT ORIENTATION"
  end

  # Instructions for opening the lid
  #
  # @return [String]
  def open_lid()
    "Click the <b>Open Lid</b> button"
  end

  # Instructions for closing the lid
  #
  # @return [String]
  def close_lid()
    "Click the <b>Close Lid</b> button"
  end

  # Instructions for starting the run
  #
  # @return [String]
  def start_run()
    "Click the <b>Start Run</b> button"
  end

  # Instructions for saving an experiment file
  #
  # @param filename [String] the name of the file (without the full path)
  # @return [String]
  def save_experiment_file(filename:)
    "Save the experiment as #{filename} in #{params[:experiment_filepath]}"
  end

  # Instructions for exporting measurements from a qPCR run
  #
  # @return [String]
  def export_measurements()
    "Click <b>Export</b><br>" +
    "Select <b>Export All Data Sheets</b><br>" +
    "Export all sheets as CSV<br>" +
    "Save files to the #{params[:export_filepath]} directory"
  end

  ########## Image Methods
  # These probably should NOT be overridden in the concrete classes

  # Image for launching the software that controls the thermocycler
  #
  # @return [String]
  def open_software_image()
    image_path(image_name: params[:open_software])
  end

  # Image for setting up the software workspace
  #
  # @return [String]
  def setup_workspace_image()
    image_path(image_name: params[:setup_workspace])
  end

  # Image for selecting the PCR program template in the software
  #
  # @return [String]
  def setup_program_image()
    image_path(image_name: params[:setup_program])
  end

  # Image for selecting the plate layout template in the software
  #
  # @return [String]
  def setup_plate_layout_image()
    image_path(image_name: params[:setup_plate_layout])
  end

  # Image for opening the lid
  #
  # @return [String]
  def open_lid_image()
    image_path(image_name: params[:open_lid])
  end

  # Image for closing the lid
  #
  # @return [String]
  def close_lid_image()
    image_path(image_name: params[:close_lid])
  end

  # Image for starting the run
  #
  # @return [String]
  def start_run_image()
    image_path(image_name: params[:start_run])
  end

  # Image for exporting measurements from a qPCR run
  #
  # @return [String]
  def export_results_image()
    image_path(image_name: params[:export_results])
  end

  ########## Template File Methods
  # These probably should NOT be overridden in the concrete classes

  def program_template_file(program:)
    template_file(
      template_name: program.program_template_name, 
      extension: :PROGRAM_EXT
    )
  end

  def layout_template_file(program:)
    template_file(
      template_name: program.layout_template_name, 
      extension: :LAYOUT_EXT
    )
  end

  private

  def default_params()
    {
      experiment_filepath: "",
      export_filepath: "",
      image_path: "",
      open_software: "open_software.png",
      setup_workspace: "setup_workspace.png",
      setup_program: "setup_program.png",
      setup_plate_layout: "setup_plate_layout.png",
      open_lid: "open_lid.png",
      close_lid: "close_lid.png",
      start_run: "start_run.png",
      export_results: "export_results.png"
    }
  end

  def image_path(image_name:)
    File.join(params[:image_path], image_name)
  end

  def template_file(template_name:, extension:)
    ext = self.class.const_get(extension)
    (template_name + '.' + ext).gsub(/\.+/, '.')
  end

end
