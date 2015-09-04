%% setStatus
% Set status settings
%
%% Syntax
e.getStatus(parameters);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.setStatus([parameter1,value1;..parameterN,valueN])</a></td>
%      <td>Set status settings.</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Set oversampling rate</b></li></a>
% </html>
%

if (~exist('e', 'var'))
        e = engduino();
end
e.setStatus([e.STATUS_OVERSAMPLING, 10]);
%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">parameters</td>
%      <td>parameters = [parameter1,value1;..parameterN,valueN]</td> 
%   </tr>
% </table>
% </html>
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td style="width:30%">res</td>
%      <td>Return status to indicate whether function has been executed (int) 0: OK, <0: Error code</td> 
%   </tr>
% </table>
% </html>
