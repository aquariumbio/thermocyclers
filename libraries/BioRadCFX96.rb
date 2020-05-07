# @author Eriberto Lopez <elopez3@uw.edu>
# @note BioRad module originally deployed as `QPCR_ThermocyclerLib`
#   on UW BIOFAB production 10/05/18

needs "Thermocyclers/AbstractThermocycler"

class BioRadCFX96 < AbstractThermocycler

  MODEL = "BioRad CFX96"
  PROGRAM_EXT = ".prcl"
  LAYOUT_EXT =  ".pltd"

  # Instantiates the class
  #
  # @return [BioRadCFX96]
  def initialize()
    super()
  end

  # Lab-specific, user-defined parameters
  #
  # @return [Hash]
  def user_defined_params()
    {
      experiment_filepath: "Desktop/_qPCR_UWBIOFAB",
      export_filepath: "Desktop/BIOFAB qPCR Exports",
      image_path: "Actions/BioRad_qPCR_Thermocycler",
      open_software_image: "open_biorad_thermo_workspace.JPG",
      setup_workspace_image: "setup_workspace.JPG",
      setup_program_image: "setting_up_qPCR_thermo_conditions.png",
      setup_plate_layout_image: "setting_up_plate_layout_v1.png",
      open_lid_image: "open_lid.png",
      close_lid_image: "close_lid.png",
      start_run_image: "start_run.png",
      export_results_image: "exporting_qPCR_quantification.png"
    }
  end
end
