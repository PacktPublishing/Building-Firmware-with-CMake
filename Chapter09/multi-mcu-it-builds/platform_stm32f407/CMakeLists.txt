add_library(platform INTERFACE)

target_link_options(platform INTERFACE
    --specs=nosys.specs
)