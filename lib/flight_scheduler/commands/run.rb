#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of Flight Scheduler.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Scheduler is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Scheduler. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Scheduler, please visit:
# https://github.com/openflighthpc/flight-scheduler
#===============================================================================

module FlightScheduler
  module Commands
    class Run < Command
      def run
        job_step = JobStepsRecord.create(
          arguments: args[1..-1],
          job_id: job_id,
          path: resolve_path(args.first),
          connection: connection,
        )
        puts "Job step #{job_step.id} added"
      end

      def job_id
        if opts.jobid
          opts.jobid
        elsif ENV['JOB_ID']
          ENV['JOB_ID']
        else
          raise InputError, <<~ERROR.chomp
            --jobid must be given
          ERROR
        end
      end
    end
  end
end