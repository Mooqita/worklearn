# Copyright 2018 Mooqita
# Copyright 2014-2015 Daniel Dent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use these files except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM node:carbon

RUN cd /usr/bin && curl https://install.meteor.com/ | sh
RUN groupadd -r nodejs && useradd -m -r -g nodejs nodejs
USER nodejs
RUN mkdir -p /home/nodejs/app
RUN mkdir -p /home/nodejs/app/.meteor/local
WORKDIR /home/nodejs/app
COPY . /home/nodejs/app
RUN npm install
EXPOSE 3000
CMD ["meteor", "run"]
