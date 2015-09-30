%% getStatus
% Returns requested status parameters
%
%% Syntax
res = e.getStatus(parameters);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.getStatus(parameters)</a></td>
%      <td>Returns requested status parameters.</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Get the oversampling rate</b></li></a>
% </html>
%

if (~exist('e', 'var'))
        e = engduino();
end
res = e.getStatus(e.STATUS_OVERSAMPLING)
%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">parameters</td>
%      <td>parameters = [KEY1, KEY2, ... , KEYn]</td> 
%   </tr>
% </table>
% </html>
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">res</td>
%      <td>res = [KEY1, VALUE1; KEY2, VALUE2; ... ; KEYn, VALUEn]</td> 
%   </tr>
% </table>
% </html>
