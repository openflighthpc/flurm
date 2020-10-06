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
    class Alloc < Command
      def run
        job = JobsRecord.create(
          min_nodes: opts.nodes,
          connection: connection,
        )
        # XXX It might not be queued.  It could have been immediately
        # allocated resources.  We should handle that here and add additional
        # output as the job changes state.  Perhaps, websockety goodness is
        # needed here.
        puts "Job #{job.id} queued and waiting for resources"
        # XXX Replace this with a sane way of detecting if the resources have
        # been allocated.
        sleep 1
        puts "Job #{job.id} allocated resources"
        run_command_and_wait(job)
        job.delete
        puts "Job #{job.id} resources deallocated"
      end

      def run_command_and_wait(job)
        command = args.first || 'bash'
        child_pid = Kernel.fork do
          opts = {
            unsetenv_others: false,
          }
          env = {
            'JOB_ID' => job.id,
          }
          Kernel.exec(env, command, *args[1..-1], **opts)
        end
        Process.wait(child_pid)
      end
    end
  end
end