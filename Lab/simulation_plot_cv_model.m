function [] = simulation_plot_cv_model(simulation_output_vector, label_vector, figure_vector)

    figure(figure_vector(1));
    for i=1:length(simulation_output_vector)
        plot(simulation_output_vector(i).tout, simulation_output_vector(i).dwupunktowa_cv);
        hold on
    end

    legend(label_vector(1), label_vector(2), label_vector(3));

    figure(figure_vector(2));

    for i=1:length(simulation_output_vector)
        plot(simulation_output_vector(i).tout, simulation_output_vector(i).output);
        hold on
    end

    legend(label_vector(1), label_vector(2), label_vector(3));
end