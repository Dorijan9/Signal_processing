function Answers = u2263074_lab()
%% ES3C5 lab submission template v1.0
%
% Please DO NOT change this header
% Please DO NOT change any code in this top-level function
% Please DO NOT change function or subfunction arguments (Input OR Output)
% DO Change function name above to u<ID>_lab(), where <ID> is your student #

% ES3C5 / ES98G 2024-2025 Lab Assignment
% Module Leader: Viji Ahanathapillai
% Modify the SUBFUNCTIONS below with the code needed to determine or
% demonstrate the answers requested.

% See the Briefing Sheet for full instructions.

% Initialise answer structure
Answers = [];

%% Template call (dummy)
Q0();

%% Remaining Calls
Answers.Q1 = Q1Fun();
Answers.Q2 = Q2Fun();
Answers.Q3 = Q3Fun();

end

%% Template Question on hypotenuse length
% This subfunction is a sample to demonstrate what is expected for comments
function c0 = Q0()
% Please DO NOT change function arguments (input OR output)
% Assign answer to c0 (double value)

% Define triangle lengths
a0 = 2; % 1st side
b0 = 1; % 2nd side

% Find length of hypothenuse
c0 = sqrt(a0^2 + b0^2); % Pythagorean theorem to find 3rd side

end

%%
%%%%%%%%%%%%%%%%%%% Start Modifying Below %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Q1 Audio Signal Processing
% Figures created must be labelled and copied to u<ID>_lab.docx
function Q1 = Q1Fun()
% Please DO NOT change function arguments above (input OR output)
% You must call a plotting function but you can label it manually.

    % Initialising outputs to guarantee they exist (unless you delete them)
    % Please DO NOT modify or move the code below
  

    Q1.audioInput =[];% Q1 part (a)
    Q1.audioNoisy = []; % Q1 part (b)
    Q1.FFTNoisy = []; % Q1 part (b)

    Q1.h = []; % Q1 part (c)
    Q1.filteredAudio = []; % Q1 part (c)

    Q1.audioChorus = []; % Q1 part (d)
    % Please DO NOT modify or move the code above
    
    %% Start your Q1 code here
    % DO NOT REMOVE OR MOVE THIS IF STATEMENT
    % WRITE YOUR CODE INSIDE THIS IF STATEMENT
    if exist('u2263074_lab_Audio.mat', 'file') == 2 ... % Update with your student ID
        && exist('u2263074_lab_signals.mat', 'file') == 2 % Update with your student ID

        load('u2263074_lab_Audio.mat', 'audioRaw') % Update with your student ID
        load('u2263074_lab_signals.mat', 'n1') % Update with your student ID
        %%
        % Q1 part (a)
        Q1.audioInput =audioRaw;
        %%
        % Q1 part (b)
        % i)
        % Add noise to the clean signal
        Q1.audioNoisy = audioRaw + n1;
        
        % ii)
        % Calculate the FFT of the noisy signal
        Q1.FFTNoisy = fft(Q1.audioNoisy);
        
        % iii)
        % Define Sampling Frequency in Hz
        fs = 22050;
        
        % Compute the frequency vector
        N = length(Q1.audioNoisy); % Number of samples
        frequencies = (0:N-1)*(fs/N); % Frequency vector in Hz
        
        % Compute magnitude of the FFT
        magnitudeFFT = abs(Q1.FFTNoisy);
        
        % Plot the magnitude of the FFT
        figure;
        plot(frequencies, magnitudeFFT);
        xlim([0, 22050]); % Set frequency range to [0, 22050) Hz
        title('Magnitude Spectrum of the Noisy Signal - u2263074 (Q1.b.iii)');
        xlabel('Frequency (Hz)');
        ylabel('|FFT(audioNoisy)|');
        grid on;
        
        % iv)
        % Find the index of the largest frequency component
        [~, maxIndex] = max(magnitudeFFT);
        maxFrequency = frequencies(maxIndex); % Frequency corresponding to the max magnitude
        maxMagnitude = magnitudeFFT(maxIndex); % Magnitude at the max frequency
        
        % Annotate the plot with the largest frequency component and its magnitude
        text(maxFrequency, maxMagnitude, sprintf(' Max Freq: %.2f Hz, Max Magnitude: %.2f', maxFrequency, maxMagnitude), ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'black', 'FontSize', 10);
        hold on;
        plot(maxFrequency, maxMagnitude, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);
        hold off;
        %%
        %Q1 part(c)
        
        % ii)
        % Define stopband
        stopbandWidth = 40; % Stopband width (±20 Hz around the largest frequency component)
        
        % Define stopband edges
        stopbandEdge1 = maxFrequency - stopbandWidth / 2;
        stopbandEdge2 = maxFrequency + stopbandWidth / 2;
        
        % Design band-stop filter
        [~, dFilt] = bandstop(Q1.audioNoisy, [stopbandEdge1, stopbandEdge2], fs, ImpulseResponse="fir");
        
        % Compute and assign impulse response
        [Q1.h, ~] = impz(dFilt); 
        
        % iii)
        % Frequency Response Plot (Zoomed and Full Spectrum)
        [h, freqRange] = freqz(dFilt, 2 * fs, fs);

        % Full Frequency Response Plot
        figure;
        plot(freqRange, 20*log10(abs(h)), 'LineWidth', 1); % 20*log10 applied to get dB
        hold on;
        plot([stopbandEdge1, stopbandEdge1], [-138, 10], 'g--', 'LineWidth', 1.5); % Start of stopband
        plot([stopbandEdge2, stopbandEdge2], [-138, 10], 'g--', 'LineWidth', 1.5); % End of stopband
        title('Frequency Response of Band-Stop Filter - u2263074 (Q1.c.iii)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        grid on;
        hold off;
        
        % Zoomed-In Frequency Response Plot
        figure;
        plot(freqRange, 20*log10(abs(h)), 'LineWidth', 1);
        hold on;
        plot([stopbandEdge1, stopbandEdge1], [-138, 10], 'g--', 'LineWidth', 1.5); % Start of stopband
        plot([stopbandEdge2, stopbandEdge2], [-138, 10], 'g--', 'LineWidth', 1.5); % End of stopband
        plot(198, -75.8037, 'ko', 'LineWidth', 1); % Maximum attenuation marker
        text(200, -70, '198 Hz', 'HorizontalAlignment', 'left'); % Add text label
        cutOffFreq1 = find(freqRange >= stopbandEdge1, 1); % Closest to stopband start
        cutOffFreq2 = find(freqRange >= stopbandEdge2, 1); % Closest to stopband end
        plot(freqRange(cutOffFreq1), 20*log10(abs(h(cutOffFreq1))), 'kx', 'LineWidth', 2);
        plot(freqRange(cutOffFreq2), 20*log10(abs(h(cutOffFreq2))), 'kx', 'LineWidth', 2);
        
        xlim([stopbandEdge1 - 20, stopbandEdge2 + 20]); % Adjusted zoom range around the stopband
        ylim([-150, 60]); % Adjusted vertical range for better visibility
        legend('Frequency Response', 'Stopband Start', 'Stopband End', ...
               'Max Attenuation: -75.8 dB', 'Cutoff Freq 1: 178 Hz', 'Cutoff Freq 2: 218 Hz');
        title('Frequency Response of Band-Stop Filter - u2263074 (Q1.c.iii)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        grid on;
        hold off;
                    
        % v) Filter the noisy signal
        Q1.filteredAudio = filter(dFilt, Q1.audioNoisy);

        % vi) Time-Domain Plot
        timeAudio1 = (0:length(Q1.audioNoisy) - 1) / fs; % Creates time vector in seconds
        
        figure;
        plot(timeAudio1, Q1.audioNoisy, 'r', 'LineWidth', 1);
        hold on;
        plot(timeAudio1, Q1.filteredAudio, 'g', 'LineWidth', 1);
        title('Noisy vs. Filtered Signal - u2263074 (Q1.c.vi)');
        xlabel('Time (s)');
        ylabel('Amplitude');
        legend('Noisy Audio', 'Filtered Audio');
        grid on;
        hold off;
        
        %%
        %Q1 part(d)
        % i)

        % Define parameters
        D1 = 551;           % Base delay time for the first chorus in samples
        D2 = 772;           % Base delay time for the second chorus in samples
        a1 = 0.44;          % Amplitude scaling factor for the first chorus
        a2 = 0.24;          % Amplitude scaling factor for the second chorus
        modulationFrequency = 1.5; % Modulation frequency in Hz
        N = length(Q1.audioInput); % Number of samples in the input signal
        timeAudio2 = (0:N-1) / fs;  % Time vector in seconds
        
        % Initialise output signal
        Q1.audioChorus = zeros(N, 1);
        
        % Precompute modulations
        mod1 = round(5 * sin(2 * pi * modulationFrequency * timeAudio2));       % Modulation for first delay
        mod2 = round(10 * sin(2 * pi * modulationFrequency * timeAudio2 + pi/2)); % Modulation for second delay
        
        % Precompute time-varying delays
        delay1 = D1 + mod1; % Total delay for the first component
        delay2 = D2 + mod2; % Total delay for the second component
        
        % Apply the chorus effect using a for-loop
        for n = 1:N
            % Check bounds for delay1
            if n - delay1(n) >= 1
                delayed1 = Q1.audioInput(n - delay1(n));
            else
                delayed1 = 0; % Out-of-bounds access handled
            end
        
            % Check bounds for delay2
            if n - delay2(n) >= 1
                delayed2 = Q1.audioInput(n - delay2(n));
            else
                delayed2 = 0; % Out-of-bounds access handled
            end
        
            % Combine the original signal with delayed components
            Q1.audioChorus(n) = Q1.audioInput(n) + a1 * delayed1 + a2 * delayed2;
        end
        
        % ii)
        % Plot the original and chorus-enhanced signals
        figure;
        plot(timeAudio2, Q1.audioInput, 'k', 'LineWidth', 1, 'DisplayName', 'Original Signal');
        hold on;
        plot(timeAudio2, Q1.audioChorus, 'r', 'LineWidth', 1, 'DisplayName', 'Chorus Effect');
        xlabel('Time (s)');
        ylabel('Amplitude');
        title('Clean Audio Signal vs Chorus Effect - u2263074 (Q1.d.ii)');
        legend show;
        grid on;
        hold off;
       
    end

end

%% Q2 Filter Design
% Figures created must be labelled and copied to u<ID>_lab.docx
function Q2 = Q2Fun()
% Please DO NOT change function arguments above (input OR output)
% You must call a plotting function but you can label it manually.

    % Initialising outputs to guarantee they exist (unless you delete them)
    % Please DO NOT modify code below
    
    Q2.filterOrder = []; % Q2 part (a)
    Q2.a = []; % Q2 part (a)
    Q2.b = []; % Q2 part (a)
    
    % Please DO NOT modify code above
    
    %% Start your Q2 code here
    % DO NOT REMOVE OR MOVE THIS IF STATEMENT
    % WRITE YOUR CODE INSIDE THIS IF STATEMENT
   
    %Q2 part(a)
    % i)
    % Parameters
    fs = 12000; % Sampling frequency in Hz 
    fo = 1500; % Target interference frequency in Hz
    tbStart = 15; % Transition band start (Hz)
    tbStop = 1; % Transition band stop (Hz)
    Rp = 1.6; % Maximum passband ripple in dB
    Rs = 44; % Maximum stopband attenuation in dB
    
    % Nyquist frequency
    fNyq = fs / 2;
    
    % Normalised frequencies
    fPass1 = (fo - tbStart) / fNyq; % Start of passband (normalised)
    fStop1 = (fo - tbStop) / fNyq;  % Start of stopband (normalised)
    fPass2 = (fo + tbStart) / fNyq; % End of passband (normalised)
    fStop2 = (fo + tbStop) / fNyq;  % End of stopband (normalised)
    
    % iii)
    % Filter order calculation using Chebyshev Type II
    [Q2.filterOrder, ~] = cheb2ord([fPass1, fPass2], [fStop1, fStop2], Rp, Rs);
    
    % Design the filter using Chebyshev Type II
    [Q2.b, Q2.a] = cheby2(Q2.filterOrder, Rs, [fStop1, fStop2], 'stop');

    %%
    %Q2 part(b)
    % i)
   
    % Frequency response calculation with high resolution
    [freqResp, w] = freqz(Q2.b, Q2.a, 2 * fs, fs); % Computes high-resolution frequency response
    
    % Full-range Magnitude and Phase Response Plot
    figure;
    subplot(2, 1, 1); % Magnitude Response
    plot(w, 20 * log10(abs(freqResp))); % Plot magnitude in dB
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    title('Magnitude Response of the Filter - u2263074 (Q2.b.i)');
    grid on;
    xlim([500, 2500]);
    ylim([-65, 10]);
    
    % Annotate passband and stopband frequencies
    hold on;
    plot([fo - tbStart, fo - tbStart], [-60, 5], 'k--', 'LineWidth', 1); % Passband start
    plot([fo + tbStart, fo + tbStart], [-60, 5], 'k--', 'LineWidth', 1); % Passband end
    plot([fo - tbStop, fo - tbStop], [-60, 5], 'r--', 'LineWidth', 1); % Stopband start
    plot([fo + tbStop, fo + tbStop], [-60, 5], 'r--', 'LineWidth', 1); % Stopband end
    legend('Magnitude Response', 'Passband Start', 'Passband End', 'Stopband Start', 'Stopband End');
    hold off;
    
    % Phase Response
    subplot(2, 1, 2);
    plot(w, angle(freqResp)); % Phase response in radians
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    title('Phase Response of the Filter');
    grid on;
    xlim([500, 2500]);
    
    % ii)

    % Zoomed-in Magnitude and Phase Response Plot
    figure;
    subplot(2, 1, 1); % Zoomed-in Magnitude Response
    magnitudeR=plot(w, 20 * log10(abs(freqResp)));
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    title('Magnitude Response of the Filter - u2263074 (Q2.b.ii)');
    grid on;
    xlim([1470, 1540]); % Focus on the stopband range
    ylim([-65, 10]);
    
    % Annotate stopband attenuation and cutoff frequencies
    hold on;
    attenPoint = plot(fo, -Rs, 'mo', 'LineWidth', 1); % Attenuation point at fo
    text(fo+1.3, -Rs, '-44 dB', 'HorizontalAlignment', 'left'); % Add text label near attenuation point

    passB1=plot([fo - tbStart, fo - tbStart], [-60, 5], 'k--', 'LineWidth', 1); % Passband start
    passB2=plot([fo + tbStart, fo + tbStart], [-60, 5], 'k--', 'LineWidth', 1); % Passband end
    stopB1=plot([fo - tbStop, fo - tbStop], [-60, 5], 'r--', 'LineWidth', 1); % Stopband start
    stopB2=plot([fo + tbStop, fo + tbStop], [-60, 5], 'r--', 'LineWidth', 1); % Stopband end
    cutoffFreq1 = plot(1491, -3, 'go', 'LineWidth', 1.5); % -3dB cutoff Freq 1
    cutoffFreq2 = plot(1509, -3, 'go', 'LineWidth', 1.5); % -3dB cutoff Freq 2
    text(1491+1.3, -3, '1491 Hz', 'HorizontalAlignment', 'left'); % Add text label near -3dB cutoff Freq 1
    text(1509-1.3, -3, '1509 Hz', 'HorizontalAlignment', 'right'); % Add text label near -3dB cutoff Freq 2
    legend([magnitudeR, passB1, passB2, stopB1, stopB2, attenPoint, cutoffFreq1, cutoffFreq2],...
           'Magnitude Response', 'Passband Start', 'Passband End', 'Stopband Start', 'Stopband End',...
           'Attenuation: -44dB', 'Cutoff Freq 1: 1491 Hz', 'Cutoff Freq 2: 1509 Hz');
    hold off;
    
    % Zoomed-in Phase Response
    subplot(2, 1, 2);
    plot(w, angle(freqResp));
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    title('Phase Response of the Filter');
    grid on;
    xlim([1470, 1530]); % Focus on the stopband range

end

%% Q3 Estimating Unknown Signal
function Q3 = Q3Fun()
% Please DO NOT change function arguments (input OR output)

    % Initialising outputs to guarantee they exist (unless you delete them)
    % Please DO NOT modify code below
    Q3.Obs = []; % Q3 part (a)

    Q3.param = []; % Q3 part (b)

    Q3.yHat = []; % Q3 part (c)

    Q3.mse = []; % Q3 part (d)

    Q3.yFFT = []; % Q3 part (e)
    Q3.fRange = []; % Q3 part (e)
    Q3.yHatFFT = []; % Q3 part (e)
    % Please DO NOT modify code above
    %%
    % DO NOT REMOVE THIS IF STATEMENT
    % WRITE YOUR CODE INSIDE THIS IF STATEMENT
    if exist('u2263074_lab_signals.mat', 'file') == 2 % Update with your student ID
        load('u2263074_lab_signals.mat', 'T') % Update with your student ID

    T_noisy = T; 
    
    % Sampling interval
    Ts = 0.045;
    
    % Time vector
    num_samples = length(T_noisy);
    time_vector = (0:Ts:(num_samples-1)*Ts);
    
    % Q3 part(a): Construct the observation matrix Θ
    Q3.Obs = [(1 - exp(-0.19.* time_vector))'  (exp(-0.24.* time_vector) .* cos(14.16.*time_vector))' (sin(47.20.* time_vector))'];

    % Q3 part(b): Parameter Estimation using Least Squares
    Q3.param = Q3.Obs \ T_noisy; 
    
    % Q3 part(c): Temperature Prediction
    Q3.yHat = Q3.Obs * Q3.param; 
    
    % Q3 part(d): Model Error Calculation (MSE)
    Q3.mse = mean((T_noisy - Q3.yHat).^2);
    
    % Q3 part(e): Frequency Domain Analysis
    % i) Compute the FFT of the noisy temperature data
    Q3.yFFT = fft(T_noisy); 
    
    % ii) Compute the FFT of the predicted temperature data
    Q3.yHatFFT = fft(Q3.yHat); 
    
    % iii) Create a frequency vector associated with the FFT results
    sFreq = 1 / Ts; % Sampling frequency
    Q3.fRange = (0:num_samples-1) * (sFreq / num_samples); % Frequency vector

    % iv) Plot the magnitude spectra of both Q3.yFFT and Q3.yHatFFT
    figure;
    % Plot FFT Magnitudes
    noisyP = plot(Q3.fRange, abs(Q3.yFFT), 'k', 'LineWidth', 1); hold on;
    predictedP = plot(Q3.fRange, abs(Q3.yHatFFT), 'r--', 'LineWidth', 1);
    
    % Add labeled markers for key magnitudes 
    predM1 = plot(0, 1368.63, 'rx', 'LineWidth', 1.5);
    predM2 = plot(2.25, 1060.54, 'rx', 'LineWidth', 1.5); 
    inM1 = plot(0, 1368.63, 'ko', 'LineWidth', 2.5);
    inM2 = plot(2.25, 1060.54, 'ko', 'LineWidth', 2.5); 
    inM3 = plot(5.446, 1127.22, 'ko', 'LineWidth', 2.5);

    % Plot Title, Labels, and Legend
    title('Magnitude Spectrum of Noisy and Predicted Temperature Data - u2263074 (Q3.e.iv)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    text(0.5, 1368.63, '0 Hz', 'HorizontalAlignment', 'left'); % Add text label
    text(2.75, 1060.54, '2.25 Hz', 'HorizontalAlignment', 'left'); % Add text label
    text(5.946, 1127.22, '5.446 Hz', 'HorizontalAlignment', 'left'); % Add text label
    legend([noisyP, predictedP, inM1, inM2, inM3, predM1, predM2], ...
           'Noisy Data', 'Predicted Data', ...
           'Input Magnitude 1: 1368.63', 'Input Magnitude 2: 1060.54', 'Input Magnitude 3: 1127.22', ...
           'Predicted Magnitude 1: 1368.63', 'Predicted Magnitude 2: 1060.54');
    
    % Set axis limits
    xlim([0, sFreq]); % Limit frequency range
    ylim([0, 1700]);    % Limit magnitude range
    hold off;
    end
end